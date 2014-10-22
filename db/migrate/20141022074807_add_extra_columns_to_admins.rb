class AddExtraColumnsToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string
    add_column :admins, :phone_number, :string
  end
end
