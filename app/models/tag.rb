class Tag < ActiveRecord::Base
  belongs_to :club
  has_many :taggings
  has_many :users, through: :taggings, source: :user

  scope :fetch_list_by_tag_name, -> (tag_name){
    where(arel_table[:tag_name].matches("%#{tag_name}%"))
  }
end
