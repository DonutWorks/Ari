require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '00 00 * * *', :times => nil do
  if Rails.application.config.auto_sms
    Rake::Task['db:deadline_check'].execute
  end
end