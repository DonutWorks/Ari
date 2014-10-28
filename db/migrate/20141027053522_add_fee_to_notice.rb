class AddFeeToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :regular_dues, :integer
    add_column :notices, :associate_dues, :integer
  end
end
