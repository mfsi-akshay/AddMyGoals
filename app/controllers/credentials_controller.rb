class CredentialsController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to goals_path if current_user.credential.present?
    @credential = Credential.new
  end

  def save
    if @credential = current_user.create_credential(credential_params)
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
