class GoalsController < ApplicationController
  def index
    return root_path unless current_user.credential.present?
  end

  def create
    puts "********************** #{params[:date]} *****************"
    goal = current_user.goals.new(:body => params[:goal][:body], date: Date.strptime(params[:date], "%m/%d/%Y"))
    respond_to do |format|
      if goal.save
        return redirect_to root_path, notice: "Goal saved sucessfully!"
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

  def fetch_goal
    @goal = current_user.goals.where(date: Date.strptime(params[:date], "%m/%d/%Y")).first_or_create
    respond_to do |format|
      format.js
    end
  end
end
