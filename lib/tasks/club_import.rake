require 'csv'

namespace :club do
  desc "Import a club data (params: [name])."
  task :import, [:name] => :environment do |t, args|
    club = Club.friendly.find(args[:name])

    club.transaction do

      # import users
      CSV.foreach('./db/seeds/exported_user.csv', headers: true) do |row|
        club.users.create!(row.to_hash.except('id', 'club_id'))
      end

      # import activities, notices
      notices = CSV.read('./db/seeds/exported_notice.csv', headers: true)
      notices = notices.map(&:to_hash)

      CSV.foreach('./db/seeds/exported_activity.csv', headers: true) do |row|
        activity = club.activities.create!(row.to_hash.except('id', 'club_id'))
        activity_notices = notices.select { |notice| notice['activity_id'] == row.to_hash['id'] and notice['notice_type'] != 'checklist' }
        activity_notices.each do |notice|
          imported_notice = activity.notices.new(notice.except('id', 'club_id', 'activity_id', 'extra_info').merge(club_id: club.id))
          imported_notice.extra_info = YAML.load(notice['extra_info']).to_hash unless notice['extra_info'].nil?
          imported_notice.save!
        end
      end

    end
  end
end