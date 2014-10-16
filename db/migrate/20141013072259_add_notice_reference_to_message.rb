class AddNoticeReferenceToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :notice_id, :integer
  end
end
