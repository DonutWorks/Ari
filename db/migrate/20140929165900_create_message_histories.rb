class CreateMessageHistories < ActiveRecord::Migration
  def change
    create_table :message_histories do |t|
      t.references :user, index: true
      t.references :message, index: true

      t.timestamps
    end
  end
end
