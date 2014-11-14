class AssigneeComment < ActiveRecord::Base

  include PublicActivity::Model
  tracked except: :destroy,
    owner: -> (controller, model_instance) { model_instance.checklist.assignees.first },
    params: {
      comment: :comment
    }

  belongs_to :checklist

  validates_presence_of :comment
end
