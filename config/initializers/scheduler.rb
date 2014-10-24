require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '00 00 * * *', :times => nil do
  Notice.deadline_send_sms
end