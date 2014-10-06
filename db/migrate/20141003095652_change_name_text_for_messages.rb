class ChangeNameTextForMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :text,  :content
  end
end
