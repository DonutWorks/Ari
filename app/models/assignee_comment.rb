class AssigneeComment < ActiveRecord::Base
  belongs_to :checklist

  validates_presence_of :comment
end
