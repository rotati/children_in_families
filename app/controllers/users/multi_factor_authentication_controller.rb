class Users::MultiFactorAuthenticationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def verify_enable
    totp = ROTP::TOTP.new(current_user.otp_secret)

    if totp.verify_with_drift(params[:multi_factor_authentication][:otp_attempt], current_user.class.otp_allowed_drift)
      current_user.otp_required_for_login = true
      current_user.save!
      redirect_to edit_user_registration_path, notice: t('.two_factor_authentication_enabled')
    else
      redirect_to edit_user_registration_path, alert: t('.two_factor_authentication_could_not_be_enabled')
    end
  end

  def verify_disabled
    totp = ROTP::TOTP.new(current_user.otp_secret)

    if totp.verify_with_drift(params[:multi_factor_authentication][:otp_attempt], current_user.class.otp_allowed_drift)
      current_user.otp_required_for_login = false
      current_user.save!
      redirect_to edit_user_registration_path, notice: t('.two_factor_authentication_disabled')
    else
      redirect_to edit_user_registration_path, alert: t('.two_factor_authentication_could_not_be_disabled')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
