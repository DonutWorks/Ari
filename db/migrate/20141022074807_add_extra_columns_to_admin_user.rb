class AddExtraColumnsToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :phone_number, :string
  end
end
