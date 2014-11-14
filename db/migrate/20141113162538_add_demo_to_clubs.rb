class AddDemoToClubs < ActiveRecord::Migration
  class Club < ActiveRecord::Base
  end

  def up
    add_column :clubs, :demo, :boolean, default: false

    Club.reset_column_information

    test_club_count = 20
    test_club_count.times do |i|
      Club.transaction do
        club = Club.create!(name: "demo_#{i+1}", logo_url: "", demo: true)
        representive = AdminUser.new(email: "demo@demo.com", club_id: club.id)
        representive.password_confirmation = representive.password = "1234"
        representive.save!(validate: false)
      end
    end
  end

  def down
    test_clubs = Club.where(demo: true)
    test_clubs.each do |club|
      admin_users = AdminUser.where(club_id: club.id)
      admin_users.destroy_all
    end
    test_clubs.destroy_all

    remove_column :clubs, :demo
  end
end
