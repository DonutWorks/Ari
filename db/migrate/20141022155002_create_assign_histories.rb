class CreateAssignHistories < ActiveRecord::Migration
  def change
    create_table :assign_histories do |t|
      t.belongs_to :user
      t.belongs_to :checklist
      t.timestamps
    end

    remove_column :checklists, :assignee
  end
end
