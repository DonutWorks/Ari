class AddColumnToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :to, :integer
    add_column :notices, :due_date, :datetime
  end
end
