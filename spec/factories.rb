FactoryGirl.define do
  factory :user do
    email "John@donutworks.com"
    username "John"
    phone_number "01012341234"
    major "CS"
  end

  factory :gate do
    title "goto google.com"
    content "google!"
    link "http://google.com"
  end
end