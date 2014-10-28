require 'rufus-scheduler'

namespace :project do
  desc "This task does scheduling for SMS"
  task init: :environment do
    raise "Not allowed to run on production" if Rails.env.production?

    create_scheduler
  end
end

def create_scheduler
  scheduler = Rufus::Scheduler.new

  scheduler.cron '00 00 * * *', :times => nil do
    if Rails.application.config.auto_sms
      Notice.deadline_send_sms
    end
  end
end