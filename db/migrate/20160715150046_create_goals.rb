class CreateGoals < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.integer :user_id
      t.text :goals
      t.time :date
    end
  end
end
