class GoalsController < ApplicationController
  def index

  end

  def create
    goal = current_user.goals.new(:goals => params[:goal][:goals], date: params[:goal][:date])
    respond_to do |format|
      if goal.save
        return redirect_to root_path, notice: "Goal saved sucessfully!"
      else
        @error = goal.errors.full_messages.first
        format.js { @error }
      end
    end
  end

  def update
    goal = Goal.find(params[:id])
    if goal.save!
        return redirect_to root_path
      else
        render :index, notice: "s!"
    end
  end

  def fetch_goal
    @goal = current_user.goals.where(date: params[:date]).first_or_create
    respond_to do |format|
      format.js
    end
  end
end
