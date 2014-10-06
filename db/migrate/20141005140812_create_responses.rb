class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :user
      t.references :notice
      t.string :status
      t.timestamps
    end
  end
end
