class AddSlugToClubsAndNotices < ActiveRecord::Migration
  def change
    add_column :clubs, :slug, :string, unique: true
    add_column :notices, :slug, :string, unique: true

    Club.reset_column_information
    Notice.reset_column_information

    Club.find_each(&:save)
    Notice.find_each(&:save)
  end
end
