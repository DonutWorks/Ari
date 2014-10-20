class CreateUserTags < ActiveRecord::Migration
  def change
    create_table :user_tags do |t|
      t.string :tag_name

      t.timestamps
    end
  end
end
