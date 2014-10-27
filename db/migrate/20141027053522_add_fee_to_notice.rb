class AddFeeToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :regular_fee, :integer
    add_column :notices, :associate_fee, :integer
  end
end
