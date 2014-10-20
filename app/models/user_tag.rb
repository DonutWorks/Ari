class UserTag < ActiveRecord::Base
  has_many :user_user_tags
  has_many :users, through: :user_user_tags, source: :user
end
