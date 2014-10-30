class CreateAssigneeComments < ActiveRecord::Migration
  def change
    create_table :assignee_comments do |t|
      t.text :comment
      t.references :checklist, index: true

      t.timestamps
    end
  end
end
