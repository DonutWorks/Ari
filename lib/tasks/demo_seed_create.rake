namespace :demo do
  desc "Create seed data (params: [name])."
  task :seed, [:name] => :environment do |t, args|
    puts "create seed data for #{args[:name]}"
    club = Club.friendly.find(args[:name])

    # clean data
    club.activities.destroy_all
    club.notices.destroy_all
    club.users.destroy_all
    club.bank_accounts.destroy_all

    # import seed data
    demo_index = 0
    Rake::Task["club:import"].execute({name: args[:name]})
    club.bank_accounts.create!(account_number: "%012d" % club.id)
    club.reload

    # create read activities
    user_count = club.users.count
    notice_count = club.notices.count

    club.notices.each do |notice|
      club.users.sample(Random.rand(user_count + 1)).each do |user|
        user.read!(notice)
      end
    end

    # create TO responses
    notice_to_checker = NoticeToChecker.new

    club.notices.select(&:to_notice?).each do |notice|
      club.users.sample(Random.rand(user_count + 1)).each do |user|
        if [true, false].sample
          status = notice_to_checker.check(notice)
          club.responses.create!(user: user, notice: notice, status: status.to_s)
        end
      end
    end

    # create vote responses
    club.notices.select(&:survey_notice?).each do |notice|
      club.users.sample(Random.rand(user_count + 1)).each do |user|
        if [true, false].sample
          club.responses.create!(user: user, notice: notice, status: %w(yes maybe no).sample)
        end
      end
    end

    # create checklist

    # expense records
    bank_account = club.bank_accounts.first
    record_date = DateTime.now
    club.notices.select(&:to_notice?).each do |notice|
      next if notice.associate_dues == 0 and notice.regular_dues == 0
      going_users = club.users.responsed_go(notice)
      going_users.sample(Random.rand(going_users.count + 1)).each do |user|
        if user.member_type == "예비단원"
          deposit = notice.associate_dues
        else
          deposit = notice.regular_dues
        end
        record = bank_account.expense_records.create!({
          record_date: record_date -= 10.seconds,
          deposit: deposit,
          withdraw: 0,
          content: user.username,
          confirm: true
        })

        record.check_dues
        record.save!
      end
    end
  end

  namespace :seed do
    task fill: :environment do
      test_clubs = Club.where(demo: true)
      test_clubs.each do |club|
        puts "Filling seed data -> #{club.name}"
        Rake::Task["demo:seed"].execute({name: club.slug})
      end
    end
  end
end