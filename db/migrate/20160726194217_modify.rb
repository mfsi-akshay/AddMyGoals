class Modify < ActiveRecord::Migration
  def change
    remove_column :goals, :datetime
    add_column :goals, :date, :datetime
  end
end
