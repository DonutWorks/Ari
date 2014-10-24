class ReindexAdminUsersByEmailAndClub < ActiveRecord::Migration
  def change
    remove_index :admin_users, :email
    add_index :admin_users, [:email, :club_id], :unique => true
  end
end
