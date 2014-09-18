# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_activation do
    user nil
    activated false
    provider "MyString"
    uid "MyString"
  end
end
