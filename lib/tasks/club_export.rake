require 'csv'

namespace :club do
  desc "Export a club data (params: [name])."
  task :export, [:name] => :environment do |t, args|
    club = Club.friendly.find(args[:name])

    # export users
    users = club.users.dup

    # remove key information
    users.each_with_index do |user, index|
      user.email = "donut#{index}@donutworks.com"
      user.phone_number = "010%08d" % index
      user.home_phone_number = "02%08d" % index
      user.emergency_phone_number = "0101%07d" % index
      user.habitat_id = "donut#{index}"
      user.birth = "9001%02d" % (index % 31 + 1)
      user.extra_info = nil
      user.uid = index
      user.student_id = "2014-%05d" % index
      user.username[index % 2 + 1] = ["주", "진", "훈", "혁"][index % 4]
    end
    export_to_csv(users)

    # export activities
    export_to_csv(club.activities)

    # export notices
    export_to_csv(club.notices)
  end

  def export_to_csv(records)
    CSV.open("./db/seeds/exported_#{records.name}.csv".downcase, "wb") do |csv|
      csv << records.attribute_names
      records.each do |record|
        csv << record.attributes.values
      end
    end
  end
end