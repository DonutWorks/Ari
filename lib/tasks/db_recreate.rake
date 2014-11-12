namespace :db do
  desc "This task does drop & migrate automatically, and create users db for SNU_Habitat when Rails.env is TEST!"
  task recreate: :environment do
    raise "Not allowed to run on production" if Rails.env.production?

    Rake::Task['db:drop'].execute
    Rake::Task['db:migrate'].execute

    create_user_snuhabitat

  end
end


def create_user_snuhabitat
  data = Roo::Excelx.new("#{Rails.root}/public/snuhabitat_for_test.xlsx")
  data.default_sheet = data.sheets.first
  normalizer = FormNormalizer.new

  habitat_club = Club.friendly.find('snu-habitat')

  (2..data.last_row).each do |i|
    user = UserModelNormalizer.normalize(normalizer, data, i)
    new_user = habitat_club.users.find_or_initialize_by(phone_number: user.phone_number)
    new_user.attributes = user.as_json(except: [:id])
    new_user.save
  end
end