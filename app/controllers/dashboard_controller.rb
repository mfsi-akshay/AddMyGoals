class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    redirect_to goals_path if current_user.credential.present?
    @credential = Credential.new
  end
end
