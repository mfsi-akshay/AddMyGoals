class Modify < ActiveRecord::Migration
  def change
    remove_colunm :goals, :datetime
    add_colunm :goals, :date, :datetime
  end
end
