FactoryGirl.define do
  sequence :phone_number do |n|
    "010%08d" % n
  end

  sequence :username do |n|
    "John#{n}"
  end

  factory :user do
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
    title "goto google.com"
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