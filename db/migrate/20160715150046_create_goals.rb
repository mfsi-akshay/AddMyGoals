class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id
      t.text :goals
      t.time :datetime
    end
  end
end
