class Checklist < ActiveRecord::Base
  before_destroy :destroy_public_activities

  include PublicActivity::Model
  tracked except: :destroy,
    owner: -> (controller, model_instance) { model_instance.assignees.first },
    params: {
      task: :task
    }

  belongs_to :club
  belongs_to :notice
  has_many :assignee_comments, dependent: :destroy
  has_many :assign_histories
  has_many :assignees, through: :assign_histories, source: :user
  accepts_nested_attributes_for :assign_histories, reject_if: lambda {|attributes| attributes['user_id'].blank?}

  validates :club_id, presence: true
  validates :task, presence: {message: "할 일을 입력해주세요."}
  validate :must_have_assignees

private
  def must_have_assignees
    errors.add(:assignees, '수행할 멤버를 할당해야 합니다.') if self.assign_histories.empty?
  end

  def destroy_public_activities
    activities = PublicActivity::Activity.where(trackable: self)
    activities.destroy_all
  end
end