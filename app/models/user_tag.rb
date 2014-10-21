class UserTag < ActiveRecord::Base
  has_many :user_user_tags
  has_many :users, through: :user_user_tags, source: :user

  scope :fetch_list_by_tag_name, -> (tag_name,count){ where("tag_name LIKE ?","%#{tag_name}%").take(count)}

end
