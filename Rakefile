# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :club do
  task create: :environment do
    club = FactoryGirl.create(:complete_club)
    representive = club.representive
    puts "Club created: #{club.name}"
    puts "Representive: { email: #{representive.email}, password: 12345678 }"
  end
end

namespace :slug do
  task create: :environment do
    Club.find_each(&:save)
    Notice.find_each(&:save)
  end
end
