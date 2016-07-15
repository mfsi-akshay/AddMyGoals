class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    byebug
    redirect_to goals_path if current_user.credentials.present?
  end
end
