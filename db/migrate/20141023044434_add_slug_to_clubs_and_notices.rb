class AddSlugToClubsAndNotices < ActiveRecord::Migration
  def up
    add_column :clubs, :slug, :string, unique: true
    add_column :notices, :slug, :string, unique: true

    Club.find_each(&:save)
    Notice.find_each(&:save)
  end

  def down
    remove_column :clubs, :slug
    remove_column :notices, :slug
  end
end
