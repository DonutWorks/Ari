class AddSlugToClubsAndNotices < ActiveRecord::Migration
  def change
    add_column :clubs, :slug, :string, unique: true
    add_column :notices, :slug, :string, unique: true

    say "After migration, do this from console: Club.find_each(&:save); Notice.find_each(&:save)"
  end
end
