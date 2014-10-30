class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :users, through: :taggings, source: :user

  scope :fetch_list_by_tag_name, -> (tag_name) {
    tag_arel = Tag.arel_table
    where(tag_arel[:tag_name].matches("%#{tag_name}%"))
  }
end