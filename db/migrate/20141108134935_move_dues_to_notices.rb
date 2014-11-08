class MoveDuesToNotices < ActiveRecord::Migration
  def change
    remove_column :activities, :associate_dues
    remove_column :activities, :regular_dues

    add_column :notices, :associate_dues, :integer
    add_column :notices, :regular_dues, :integer
  end
end
