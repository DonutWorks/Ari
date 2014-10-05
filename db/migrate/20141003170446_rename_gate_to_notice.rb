class RenameGateToNotice < ActiveRecord::Migration
  def change
    rename_table :gates, :notices
  end
end
