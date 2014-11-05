class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :activity_type
      t.datetime :event_at

      t.timestamps
    end
  end
end
