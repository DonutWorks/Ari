class AddSlugToClubsAndNotices < ActiveRecord::Migration
  def change
    add_column :clubs, :slug, :string, unique: true
    add_column :notices, :slug, :string, unique: true
  end
end
