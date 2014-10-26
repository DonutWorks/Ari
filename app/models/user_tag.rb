class UserTag < ActiveRecord::Base
  has_many :user_user_tags
  has_many :users, through: :user_user_tags, source: :user

  scope :fetch_list_by_tag_name, -> (tag_name){
    user_tag_arel = UserTag.arel_table
    where(user_tag_arel[:tag_name].matches("%#{tag_name}%"))
  }

end
