class ChangeGenerationIdType < ActiveRecord::Migration
  def change
    remove_column :users, :generation_id
    add_column :users, :generation_id, :float
  end
end
