class GoalsController < ApplicationController
  def index

  end

  def save
    byebug
  end

  def fetch_goals
    @goal = Goal.first
    respond_to do |format|
      format.js
    end
  end
end
