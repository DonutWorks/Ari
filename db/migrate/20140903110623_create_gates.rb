class CreateGates < ActiveRecord::Migration
  def change
    create_table :gates do |t|
      t.string :title
      t.string :content
      t.string :link
      t.datetime :duedate

      t.timestamps
    end
  end
end
