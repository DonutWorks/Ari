class MoveDuesToActivity < ActiveRecord::Migration
  def change
    remove_column :notices, :regular_dues
    remove_column :notices, :associate_dues

    add_column :activities, :regular_dues, :integer
    add_column :activities, :associate_dues, :integer
  end
end
