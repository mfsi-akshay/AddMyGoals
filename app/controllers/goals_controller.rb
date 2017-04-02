class GoalsController < ApplicationController
  before_filter :authenticate_user!

  def index
    return root_path unless current_user.credential.present?
  end

  def create
    @goal = current_user.goals.new(:body => params[:goal][:body], date: Date.strptime(params[:date], "%m/%d/%Y"))
    respond_to do |format|
      if @goal.save
        format.js
      else
        @error = goal.errors.full_messages.first
        format.js { render "goals/show_error" }
      end
    end
  end

  def update
    goal = Goal.find(params[:id])
    goal.body = params[:goal][:body]
    respond_to do |format|
      if goal.save
        return redirect_to root_path, notice: "Success!"
      else
        @error = goal.errors.full_messages.first
        format.js { render "goals/show_error"  }
      end
    end
  end

  def fetch_goals
    @goals = current_user.goals.where(date: Date.strptime(params[:date], "%m/%d/%Y"))
    @goal = Goal.new(date: Date.strptime(params[:date], "%m/%d/%Y"))
    respond_to do |format|
      format.js
    end
  end
end
