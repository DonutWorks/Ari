class AddNoticesToDefaultActivity < ActiveRecord::Migration
  class Activity < ActiveRecord::Base
  end

  class Notice < ActiveRecord::Base
  end

  def up
    activity = Activity.create!(title: "2014-2학기 활동", description: "2014년 2학기 서울대학교 해비타트의 활동 내역입니다.", event_at: Time.now)

    Notice.reset_column_information
    Notice.all.each do |notice|
      notice.update_attributes!(activity_id: activity.id)
    end
  end

  def down
    activity = Activity.find_by(title: "2014-2학기 활동")
    activity.destroy

    Notice.reset_column_information
    Notice.all.each do |notice|
      notice.update_attributes!(activity_id: nil)
    end
  end
end
