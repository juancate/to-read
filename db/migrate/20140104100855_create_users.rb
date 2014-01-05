class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |user|
      user.string :login,             :null => false
      user.string :email,             :null => false
      user.string :crypted_password,  :null => false
      user.string :password_salt,     :null => false
      user.string :persistence_token, :null => false
      user.timestamps
    end
  end

  def down
    drop_table :users
  end
end
