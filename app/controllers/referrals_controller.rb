class ReferralsController < AdminController
  load_and_authorize_resource

  before_action :find_client
  # before_action :find_referred_to_ngo, only: :index

  def index
    if params[:referral_type].present?
      if params[:referral_type] == 'referred_to'
        @referrals = @client.referrals.where.not(referred_to: Organization.current.short_name)
      else
        @referrals = @client.referrals.where(referred_to: Organization.current.short_name, saved: true)
      end
    end
  end

  def new
    if params[:ngo].present?
      @referral = @client.referrals.new({referred_to: params[:ngo]})
    else
      @referral = @client.referrals.new
    end
  end

  def create
    @referral = @client.referrals.new(referral_params)
    if @referral.save
      redirect_to client_referral_path(@client, @referral), notice: t('.successfully_created')
    else
      render :new
    end
  end

  def edit
    @referral = @client.referrals.find(params[:id])
  end

  def show
    respond_to do |format|
      format.html do
        @referral = @client.referrals.find(params[:id])
      end
      format.pdf do
        form           = params[:form]
        @referred_to   = Organization.find_by(short_name: @referral.referred_to).try(:full_name)
        @referred_from = Organization.find_by(short_name: @referral.referred_from).try(:full_name)
        form_title     = "Referral Client To #{@referred_to}"
        client_name    = @referral.client_name
        pdf_name       = "#{client_name} - #{form_title}"
        render  pdf:      pdf_name,
                template: 'referrals/show.pdf.haml',
                page_size: 'A4',
                layout:   'pdf_design.html.haml',
                show_as_html: params.key?('debug'),
                header: { html: { template: 'referrals/pdf/header.pdf.haml' } },
                footer: { html: { template: 'referrals/pdf/footer.pdf.haml' }, right: '[page] of [topage]' },
                margin: { left: 0, right: 0, top: 10 },
                dpi: '72',
                disposition: 'attachment'
      end
    end

  end

  def update
    @referral = @client.referrals.find(params[:id])

    if @referral.update_attributes(referral_params)
      redirect_to client_referral_path(@client, @referral), notice: t('.successfully_updated')
    else
      render :edit
    end
  end

  private

  # def find_referred_to_ngo
  #   @referred_to_ngo = Organization.find_by(short_name: params[:ngo])
  #   raise ActionController::RoutingError.new('Not Found') if @referred_to_ngo.nil?
  # end

  def find_client
    @client = Client.accessible_by(current_ability).friendly.find(params[:client_id])
  end

  def referral_params
    params.require(:referral).permit(:referred_to, :referred_from, :name_of_referee, :referee_id, :referral_phone, :date_of_referral, :referral_reason, :client_name, :slug, :consent_form)
  end
end
