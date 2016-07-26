class ChangeGoals < ActiveRecord::Migration
  def change
    #change_column(:goals, :date, :datetime)
    rename_column(:goals, :goals, :body)
  end
end
