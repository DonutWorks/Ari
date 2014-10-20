class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.text :task
      t.text :assignee
      t.references :notice, index: true

      t.timestamps
    end
  end
end
