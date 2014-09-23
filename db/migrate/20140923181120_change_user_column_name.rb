class ChangeUserColumnName < ActiveRecord::Migration
  def up
    rename_column :users, :group_id, :generation_id
  end
  def down
    rename_column :users, :generation_id, :group_id
  end

end
