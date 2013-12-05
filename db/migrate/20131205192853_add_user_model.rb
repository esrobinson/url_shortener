class AddUserModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
    end

    add_index :users, :email, :unique => true
  end
end
