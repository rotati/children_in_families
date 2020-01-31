class CallsController < AdminController
  # load_and_authorize_resource find_by: :id, except: :quantitative_case
  load_and_authorize_resource find_by: :id

  # before_action :set_association, except: [:index, :destroy, :version]
  before_action :set_association, only: [:new, :edit, :update, :show]
  before_action :country_address_fields, only: [:new]

  def index
    @calls_grid = CallsGrid.new(params[:calls_grid]) do |scope|
      scope.order(:created_at).page(params[:page]).page(params[:page]).per(20)
    end
    respond_to do |f|
      f.html do
        @calls_grid
      end
      f.xls do
        send_data  @calls_grid.to_xls, filename: "calls_report-#{Time.now}.xls"
      end
    end
  end

  def new
    @referee  = Referee.new
    @carer  = Carer.new
    @client = Client.new
    @referees = Referee.all
    @providing_update_clients = Client.accessible_by(current_ability).map{ |client| { label: client.name, value: client.id }}
    @necessities = Necessity.order(:created_at)
    @protection_concerns = ProtectionConcern.order(:created_at)
    @call = Call.new
  end

  def show
    @call = Call.find(params[:id])
    @referee = @call.referee
    @clients = @call.clients.map{|client| {slug: client.slug, full_name: client.en_and_local_name, gender: client.gender }}
  end

  def edit
    @call = Call.find(params[:id])
  end

  def update
    call = Call.find(params[:id])

    if call.update_attributes(call_params)
      render json: call
    else
      render json: call.errors
    end
  end

  def edit_referee
    @referees = Referee.all
    @call = Call.find(params[:call_id])
    @referee = @call.referee

    # OVERRIDE THE country_address_fields method
    @current_provinces = Province.order(:name)
    @referee_districts = @referee&.province&.districts || []
    @referee_communes = @referee&.province&.districts&.flat_map(&:communes) || []
    @referee_villages = @referee_communes&.flat_map(&:villages) || []
    @address_types = Client::ADDRESS_TYPES.map{|type| {label: type, value: type.downcase}}
  end

  def update_referee

  end

  private

  def call_params
    params.require(:call).permit(
                            :phone_call_id, :receiving_staff_id, :referee_id,
                            :start_datetime, :end_datetime, :call_type
                          )
  end

  def remove_blank_exit_reasons
    return if params[:client][:exit_reasons].blank?
    params[:client][:exit_reasons].reject!(&:blank?)
  end

  def set_association
    @agencies        = Agency.order(:name)
    @donors          = Donor.order(:name)
    @users           = User.non_strategic_overviewers.order(:first_name, :last_name).map { |user| [user.name, user.id] }
    @interviewees    = Interviewee.order(:created_at)
    @client_types    = ClientType.order(:created_at)
    @needs           = Need.order(:created_at)
    @problems        = Problem.order(:created_at)

    subordinate_users = User.where('manager_ids && ARRAY[:user_id] OR id = :user_id', { user_id: current_user.id }).map(&:id)
    if current_user.admin?
      @families        = Family.order(:name)
    elsif current_user.manager?
      exited_client_ids = exited_clients(subordinate_users)
      family_ids = current_user.families.ids
      family_ids += User.joins(:clients).where(id: subordinate_users).where.not(clients: { current_family_id: nil }).select('clients.current_family_id AS client_current_family_id').map(&:client_current_family_id)
      family_ids += Client.where(id: exited_client_ids).pluck(:current_family_id)
      clients     = Client.accessible_by(current_ability)
      family_ids += clients.where(user_id: current_user.id).pluck(:current_family_id)

      @families = Family.where(id: family_ids)
    elsif current_user.case_worker?
      family_ids = current_user.families.ids
      family_ids += User.joins(:clients).where(id: current_user.id).where.not(clients: { current_family_id: nil }).select('clients.current_family_id AS client_current_family_id').map(&:client_current_family_id)
      @families = Family.where(id: family_ids)
    end

    @relation_to_caller = Client::RELATIONSHIP_TO_CALLER.map{|relationship| {label: relationship, value: relationship.downcase}}
    @client_relationships = Carer::CLIENT_RELATIONSHIPS.map{|relationship| {label: relationship, value: relationship.downcase}}
    @address_types = Client::ADDRESS_TYPES.map{|type| {label: type, value: type.downcase}}
    @phone_owners = Client::PHONE_OWNERS.map{|owner| {label: owner, value: owner.downcase}}
    @referral_source = []
    @referral_source_category = referral_source_name(ReferralSource.parent_categories)
    # country_address_fields
  end

  def referral_source_name(referral_source)
    if I18n.locale == :km
      referral_source.map{|ref| [ref.name, ref.id] }
    else
      referral_source.map do |ref|
        if ref.name_en.blank?
          [ref.name, ref.id]
        else
          [ref.name_en, ref.id]
        end
      end
    end
  end

  def country_address_fields
    selected_country = Setting.first.try(:country_name) || params[:country]
    current_org = Organization.current.short_name
    Organization.switch_to 'shared'
    @birth_provinces = []
    ['Cambodia', 'Thailand', 'Lesotho', 'Myanmar', 'Uganda'].map{ |country| @birth_provinces << [country, Province.country_is(country.downcase).map{|p| [p.name, p.id] }] }
    Organization.switch_to current_org

    @current_provinces        = Province.order(:name)
    # @states = State.order(:name)
    # @townships = []

    @districts = []
    @subdistricts = []
    @communes = []
    @villages = []

    province_ids = Referee.where.not(province_id: nil).pluck(:province_id).uniq
    districts = District.where(province_id: province_ids)
    communes = Commune.where(district_id: districts.ids)
    villages = Village.where(commune_id: communes.ids)
    @referee_districts = districts
    @referee_communes  = communes
    @referee_villages  = villages

    @carer_districts = []
    @carer_communes  = []
    @carer_villages  = []
  end

  def exited_clients(user_ids)
    sql = user_ids.map do |user_id|
      "versions.object_changes ILIKE '%user_id:\n- \n- #{user_id}\n%'"
    end.join(" OR ")
    client_ids = PaperTrail::Version.where(item_type: 'CaseWorkerClient', event: 'create').where(sql).map do |version|
      client_id = version.changeset[:client_id].last
    end
    Client.where(id: client_ids, status: 'Exited').ids
  end
end
