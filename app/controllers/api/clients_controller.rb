module Api
  class ClientsController < Api::ApplicationController

    def search_client
      clients = Client.all.where("given_name ILIKE ? OR family_name ILIKE ? OR local_given_name ILIKE ? OR local_family_name ILIKE ? OR slug ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%").select(:id, :slug, :given_name, :family_name, :local_given_name, :local_family_name)
      render json: clients, serializer: false
    end

    def compare
      render json: find_client_in_organization
    end

    def render_client_statistics
      render json: client_statistics
    end

    def find_client_case_worker
      client = Client.find(params[:id])
      user_ids = client.users.non_strategic_overviewers.where.not(id: params[:user_id]).ids
      render json: { user_ids:  user_ids }
    end

    def assessments
      @assessments_count ||= Assessment.joins(:client).where(default: params[:default], client_id: params[:client_ids].split('/')).count
      render json: { recordsTotal:  @assessments_count, recordsFiltered: @assessments_count, data: data }
    end

    def create
      client = Client.new(client_params)

      referee = Referee.new(referee_params)
      referee.save

      carer = Carer.new(carer_params)
      carer.save

      client.referee_id = referee.id
      client.carer_id = carer.id

      if client.save
        render json: { id: client.slug }, status: :ok
      else
        render json: client.errors, status: :unprocessable_entity
      end
    end

    def update
      client = Client.find(params[:client][:id])
      Family.where('children @> ARRAY[?]::integer[]', [client.id]).each do |family|
        family.children = family.children - [client.id]
        family.save
      end
      Referee.where('id IN (?)', client.referee_id).update_all(referee_params)
      Carer.where('id IN(?)', client.carer_id).update_all(carer_params)
      if client.update_attributes(client_params)
        if params[:client][:assessment_id]
          assessment = Assessment.find(params[:client][:assessment_id])
          # redirect_to client_assessment_path(client, assessment), notice: t('.assessment_successfully_created')
        else
          render json: { id: client.slug }, status: :ok
        end
      else
        render json: client.errors, status: :unprocessable_entity
      end
    end

    private

    def client_params
      params.require(:client).permit(
            :slug, :archived_slug, :code, :name_of_referee, :main_school_contact, :rated_for_id_poor, :what3words, :status, :country_origin,
            :kid_id, :assessment_id, :given_name, :family_name, :local_given_name, :local_family_name, :gender, :date_of_birth,
            :birth_province_id, :initial_referral_date, :referral_source_id, :telephone_number,
            :referral_phone, :received_by_id, :followed_up_by_id,
            :follow_up_date, :school_grade, :school_name, :current_address,
            :house_number, :street_number, :suburb, :description_house_landmark, :directions, :street_line1, :street_line2, :plot, :road, :postal_code, :district_id, :subdistrict_id,
            :has_been_in_orphanage, :has_been_in_government_care,
            :relevant_referral_information, :province_id,
            :state_id, :township_id, :rejected_note, :live_with, :profile, :remove_profile,
            :gov_city, :gov_commune, :gov_district, :gov_date, :gov_village_code, :gov_client_code,
            :gov_interview_village, :gov_interview_commune, :gov_interview_district, :gov_interview_city,
            :gov_caseworker_name, :gov_caseworker_phone, :gov_carer_name, :gov_carer_relationship, :gov_carer_home,
            :gov_carer_street, :gov_carer_village, :gov_carer_commune, :gov_carer_district, :gov_carer_city, :gov_carer_phone,
            :gov_information_source, :gov_referral_reason, :gov_guardian_comment, :gov_caseworker_comment, :commune_id, :village_id, :referral_source_category_id, :referee_id, :carer_id,
            :address_type, :phone_owner, :client_phone, :client_email, :referee_relationship, :outside, :outside_address,
            interviewee_ids: [],
            client_type_ids: [],
            user_ids: [],
            agency_ids: [],
            donor_ids: [],
            quantitative_case_ids: [],
            custom_field_ids: [],
            tasks_attributes: [:name, :domain_id, :completion_date],
            client_needs_attributes: [:id, :rank, :need_id],
            client_problems_attributes: [:id, :rank, :problem_id],
            family_ids: []
          )
    end

    def referee_params
      params.require(:referee).permit(
        :name, :phone, :outside, :address_type, :commune_id, :current_address, :district_id, :email, :gender, :house_number, :outside_address, :province_id, :street_number, :village_id, :anonymous
      )
    end

    def carer_params
      params.require(:carer).permit(
        :name, :phone, :outside, :address_type, :current_address, :email, :gender, :house_number, :street_number, :outside_address, :commune_id, :district_id, :province_id,  :village_id, :client_relationship, :same_as_client
      )
    end

    def find_client_in_organization
      results = []
      similar_fields = Client.find_shared_client(params)
      { similar_fields: similar_fields }
    end

    def client_statistics
      @csi_statistics = CsiStatistic.new($client_data).assessment_domain_score.to_json
      @enrollments_statistics = ActiveEnrollmentStatistic.new($client_data).statistic_data.to_json
      { text: "#{@csi_statistics} & #{@enrollments_statistics}" }
    end

    def data
      assessment_domain_hash = {}
      client_data = []
      assessment_data.each do |assessment|
        assessment_domain_hash = AssessmentDomain.where(assessment_id: assessment.id).pluck(:domain_id, :score).to_h if assessment.assessment_domains.present?
        domain_scores = domains.ids.map { |domain_id| assessment_domain_hash.present? ? ["domain_#{domain_id}", assessment_domain_hash[domain_id]] : ["domain_#{domain_id}", ''] }

        client_hash = { slug: assessment.client.slug,
          name: assessment.client.en_and_local_name,
          'assessment-number': assessment.client.assessments.count,
          date: assessment.created_at.strftime('%d %B %Y')
        }
        client_hash.merge!(domain_scores.to_h)
        client_data << client_hash
      end

      client_data
    end

    def assessment_data
      @assessments ||= fetch_assessments
    end

    def fetch_assessments
      # .select("assessments.id, clients.assessments_count as count, clients.id as client_id, clients.slug as client_slug, assessments.created_at as date")
      assessments = Assessment.joins(:client).where(default: params[:default], client_id: params[:client_ids].split('/'))
      assessments = assessments.includes(:assessment_domains).order("#{sort_column} #{sort_direction}").references(:assessment_domains, :client)

      assessment_data = params[:length] != '-1' ? assessments.page(page).per(per_page) : assessments
    end

    def domains
      @domains ||= params[:default] == 'true' ? Domain.csi_domains : Domain.custom_csi_domains
    end

    def page
      params[:start].to_i/per_page + 1
    end

    def per_page
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def sort_column
      domains_fields = domains.map { |domain|  "assessment_domains.score" }
      columns = ["regexp_replace(clients.slug, '\\D*', '', 'g')::int", "clients.given_name", "clients.assessments_count", "assessments.created_at", *domains_fields]
      columns[params[:order]['0']['column'].to_i]
    end

    def sort_direction
      params[:order]['0']['dir'] == "desc" ? "desc" : "asc"
    end
  end
end
