class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    change_column_null :users, :username, false
    change_column_null :users, :email, true
    remove_index :users, :email
  end
end
