class AddUserNewFields < ActiveRecord::Migration
  def change
    add_column :users, :group_id, :string
    add_column :users, :student_id, :string
    add_column :users, :sex, :string
    add_column :users, :home_phone_number, :string
    add_column :users, :emergency_phone_number, :string
    add_column :users, :habitat_id, :string
    add_column :users, :member_type, :string
  end
end
