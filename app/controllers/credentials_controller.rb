class CredentialsController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to goals_path if current_user.credential.present?
    @credential = Credential.new
  end

  def save
    byebug
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    encrypted_password = crypt.encrypt_and_sign(params[:credential][:password])
    if @credential = current_user.create_credential(username: params[:credential][:username], password: encrypted_password)
      redirect_to goals_path
    else
      render :index
    end
  end

  private
  def credential_params
    params.require(:credential).permit(:username, :password)
  end
end
