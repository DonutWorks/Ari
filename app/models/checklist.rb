class Checklist < ActiveRecord::Base
  has_many :assignee_comments
  belongs_to :notice

  validates :task, presence: {message: "할 일을 입력해주세요."}
  validates :assignee, presence: {message: "회원이 할당되어야 합니다"}

  before_validation :normalize_phone_number

private 
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    begin
      self.assignee = normalizer.normalize(assignee) if !assignee.blank?
    rescue FormNormalizers::NormalizeError => e
      errors.add(:assignee, "가 잘못되었습니다.")
    end
  end
end