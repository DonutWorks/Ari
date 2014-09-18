# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activation_ticket do
    email "MyString"
    activation nil
  end
end
