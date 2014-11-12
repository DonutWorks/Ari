namespace :club do
  desc "Create a new club (params: [name, logo_url])."
  task :create, [:name, :logo_url] => :environment do |t, args|
    club = Club.create(args.to_hash)
    puts club.inspect
  end

  namespace :create do
    desc "Create a test club for development environment."
    task test: :environment do
      club = FactoryGirl.create(:complete_club)
      representive = club.representive
      club.bank_accounts.first.update(account_number: "110383537755")


      puts "Club created: #{club.name}"
      puts "Representive: { email: #{representive.email}, password: 12345678 }"
    end

    desc "Create a representive of club (params: [email, password, club_name, name, phone_number])."
    task :representive, [:email, :password, :club_name, :name, :phone_number] => :environment do |t, args|
      club = Club.friendly.find(args[:club_name].downcase)
      admin_user = club.admin_users.new({
        email: args[:email],
        name: args[:name],
        phone_number: args[:phone_number]
      })
      admin_user.password_confirmation = admin_user.password = args[:password]
      admin_user.save!

      puts admin_user.inspect
    end

    desc "Create a bank account of club (params: [account_number, club_name])."
    task :bank_account, [:account_number, :club_name] => :environment do |t, args|
      club = Club.friendly.find(args[:club_name].downcase)
      account_number = :account_number
      bank_account = club.bank_accounts.new({
        account_number: args[:account_number]
        })

      bank_account.save!

      puts bank_account.inspect
    end

  end
end