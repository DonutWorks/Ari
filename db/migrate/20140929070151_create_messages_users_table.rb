class CreateMessagesUsersTable < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.timestamps
    end

    create_table :messages_users, id: false do |t|
      t.belongs_to :message
      t.belongs_to :user
    end
  end
end
