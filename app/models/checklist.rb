class Checklist < ActiveRecord::Base
  has_many :assignee_comments
  has_many :assign_histories
  has_many :assignees, through: :assign_histories, source: :user
  accepts_nested_attributes_for :assign_histories, reject_if: lambda {|attributes| attributes['user_id'].blank?} 

  belongs_to :notice

  validates :task, presence: {message: "할 일을 입력해주세요."}
  validate :must_has_assignees

private
  def must_has_assignees
    if self.assign_histories.empty?
      errors.add(:assignees, '수행할 회원을 할당해야 합니다.') if self.assign_histories.empty?
    end
  end
end