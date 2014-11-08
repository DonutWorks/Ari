class AddIndexToColumnsForPerformance < ActiveRecord::Migration
  def change
    # foreign keys
    add_index :invitations, :user_id
    add_index :messages, :notice_id
    add_index :read_activity_marks, :reader_id
    add_index :responses, :user_id
    add_index :responses, :notice_id
    add_index :assign_histories, :user_id
    add_index :assign_histories, :checklist_id
    add_index :taggings, :user_id
    add_index :taggings, :tag_id

    # columns used in polymorphic conditional joins
    add_index :read_activity_marks, :readable_id
    add_index :read_activity_marks, :readable_type

    # columns used in uniqueness validations
    add_index :users, :email
    add_index :users, :phone_number

    # boolean columns
    add_index :checklists, :finish

    # state columns
    add_index :notices, :notice_type

    # other columns used in where clauses
    add_index :users, :provider
    add_index :users, :uid
  end
end
