require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '00 00 * * *', :times => nil do
  if Rails.application.config.auto_sms
    Notice.deadline_send_sms
  end
end