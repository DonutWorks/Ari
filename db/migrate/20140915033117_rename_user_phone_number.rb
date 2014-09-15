class RenameUserPhoneNumber < ActiveRecord::Migration
  def change
  	rename_column :users, :phonenumber, :phone_number
  end
end
