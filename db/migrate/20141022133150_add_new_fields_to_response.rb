class AddNewFieldsToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :absence, :integer, default: 0
    add_column :responses, :dues, :integer, default: 0
    add_column :responses, :memo, :string
  end
end
