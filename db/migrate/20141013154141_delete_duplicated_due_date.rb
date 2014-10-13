class DeleteDuplicatedDueDate < ActiveRecord::Migration
  def change
    remove_column :notices, :duedate
  end
end
