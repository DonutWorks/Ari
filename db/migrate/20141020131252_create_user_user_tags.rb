class CreateUserUserTags < ActiveRecord::Migration
  def change
    create_table :user_user_tags do |t|
      t.integer :user_id
      t.integer :user_tag_id

      t.timestamps
    end
  end
end
