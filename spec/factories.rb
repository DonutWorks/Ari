FactoryGirl.define do
  sequence :phone_number do |n|
    "010%08d" % n
  end

  factory :user do
    username "John"
    email { "#{username}@donutworks.com" }
    phone_number
    major "CS"
  end

  factory :gate do
    title "goto google.com"
    content "google!"
    link "http://google.com"
  end

  factory :provider_token do
    provider "kakao"
    uid "1234"
  end
end