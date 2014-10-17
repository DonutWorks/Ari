FactoryGirl.define do
  sequence :phone_number do |n|
    "010%08d" % n
  end

  factory :user do
    username "John"
    email { "#{username}@donutworks.com" }
    phone_number "010-1111-2222"
    major "CS"
    member_type "정단원"
  end

  factory :notice do
    title "goto google.com"
    content "google!"
    link "http://google.com"
    notice_type "external"
  end
end