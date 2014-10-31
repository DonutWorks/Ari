namespace :db do
  desc "This task checks which notices reach deadline and send SMS to participants"
  task deadline_check: :environment do
    raise "Not allowed to run on production" if Rails.env.production?

    deadline_send_sms
  end
end

def deadline_send_sms
  sms_sender = SmsSender.new

  Notice.where(notice_type: 'to').where(due_date: Date.today + 3.days).find_each do |notice|
    Response.responsed_to_go(notice).find_each do |response|
      sms_sender.send_message("[" + notice.title + "] 공지의 신청이 마감 되었습니다.", notice.id, response.user.id)
    end
  end
end