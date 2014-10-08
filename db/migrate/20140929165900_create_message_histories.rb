class CreateMessageHistories < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.timestamps
    end
    
    create_table :message_histories do |t|
      t.references :user, index: true
      t.references :message, index: true

      t.timestamps
    end
  end
end
