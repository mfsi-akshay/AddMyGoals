class GoalsController < ApplicationController
  def index

  end

  def create
    goal = Goal.new(:goals => params[:goal][:goals])
    respond_to do |format|
      if goal.save
        return redirect_to root_path, notice: "Goal saved sucessfully!"
      else
        format.js {}
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
    @goal = Goal.new
    respond_to do |format|
      format.js
    end
  end
end
