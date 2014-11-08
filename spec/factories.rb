FactoryGirl.define do
  sequence :phone_number do |n|
    "010%08d" % n
  end

  sequence :username do |n|
    "John#{n}"
  end

  factory :club do
    sequence(:name) { |n| "DonutWorks#{n}" }

    trait :with_representive do
      after(:create) do |club|
        FactoryGirl.create(:admin_user, club: club)
      end
    end

    trait :with_club_members do
      after(:create) do |club|
        FactoryGirl.create_list(:user, 3, club: club)
      end
    end

    trait :with_notices do
      after(:create) do |club|
        FactoryGirl.create_list(:notice, 3, club: club)
      end
    end

    factory :complete_club, traits: [:with_representive, :with_club_members, :with_notices]
  end

  factory :admin_user do
    club
    name :username
    phone_number
    email { "#{name}@donutworks.com" }

    after(:build) do |admin|
      admin.password_confirmation = admin.password = "12345678"
    end
  end

  factory :user do
    club
    username
    email { "#{username}@donutworks.com" }
    phone_number
    major "CS"
    member_type "정단원"
  end


  factory :activity do
    title "2014-2 Acitivity"
    description "This is activity"
    event_at Time.now
  end

  factory :notice do
    club
    sequence(:title) { |n| "notice title #{n}" }
    content "google!"
    link "http://google.com"
    notice_type "external"

    factory :to_notice do
      notice_type "to"
      to 10
      due_date Date.today + 10.days
      regular_dues 20000
    end
  end

  factory :expense_record do
    record_date "2000-01-01"
    deposit 20000
    withdraw 0
    content "John"
  end

  factory :response do
    status "go"
  end

  factory :message do
    content "go"
  end
end