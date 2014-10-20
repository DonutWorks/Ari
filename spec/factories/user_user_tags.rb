# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_user_tag, :class => 'UserUserTags' do
    user_id 1
    user_tag_id 1
  end
end
