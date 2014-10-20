class Checklist < ActiveRecord::Base
  has_many :assignee_comments
  belongs_to :notice
end
