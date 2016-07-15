class AddCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.integer :user_id
      t.string :username
      t.string :password
    end
  end
end
