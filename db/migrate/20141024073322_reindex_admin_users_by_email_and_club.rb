class ReindexAdminUsersByEmailAndClub < ActiveRecord::Migration
  def up
    remove_index :admin_users, :email
    add_index :admin_users, [:email, :club_id], :unique => true
  end

  def down
    remove_index :admin_users, [:email, :club_id]
    # irreversible
    add_index :admin_users, :email, :unique => true
  end
end
