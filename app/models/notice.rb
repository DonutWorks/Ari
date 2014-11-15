require 'addressable/uri'

class Notice < ActiveRecord::Base
  before_destroy :destroy_public_activities

  NOTICE_TYPES = %w(external plain survey to checklist)
  NOTICE_TYPES.each do |type|
    define_method("#{type}_notice?") do
      notice_type == type
    end
  end

  Response::STATUSES.each do |status|
    define_method("#{status}_responses") do
      responses.where(status: status)
    end
  end

  belongs_to :club
  belongs_to :activity
  has_many :responses, dependent: :destroy
  has_many :messages
  has_many :checklists, dependent: :destroy
  accepts_nested_attributes_for :checklists, reject_if: lambda {|attributes| attributes['task'].blank?}

  extend FriendlyId
  friendly_id :title, use: :slugged

  # for korean
  def normalize_friendly_id(value)
    super(Gimchi.romanize(value.to_s, number: false))
  end

  acts_as_readable

  before_create :copy_event_at_to_due_date
  before_validation :fill_club_id
  before_save :make_redirectable_url!
  before_save :change_candidates_status, if: :to_notice?

  validates :title, presence: true
  validates :link, presence: true, if: :external_notice?
  validates :content, presence: true
  validates :notice_type, presence: { message: "유형을 선택해주십시오." },
   inclusion: { in: NOTICE_TYPES, message: "올바르지 않은 유형입니다." }
  validates :club_id, presence: true
  validates :activity_id, presence: true
  validates :to, numericality: { greater_than_or_equal_to: 1 }, if: :to_notice?
  validate :to_adjustable?, if: :to_notice?
  validate :must_have_checklists, if: :checklist_notice?

  scope :created_at_desc, -> { order(created_at: :desc) }

  def club_readers
    club.users.merge(self.readers)
  end

  def club_unreaders
    club.users.merge(self.unreaders)
  end

  def calculate_dues_sum
    if self.notice_type == 'to'

      sum = 0
      go = 0
      wait = 0

      self.responses.where(dues: 1).each do |response|
        case response.user.member_type
        when "예비단원"
          self.associate_dues ? sum += self.associate_dues : sum += 0
        else
          self.regular_dues ? sum += self.regular_dues : sum += 0
        end

        case response.status
        when "go"
          go += 1
        when "wait"
          wait += 1
        end
      end


      return {notice: self, go: go, wait: wait, sum: sum}
    else 
      return 'not_to'
    end
  end

private
  def make_redirectable_url!
    unless link.blank?
      self.link = Addressable::URI.heuristic_parse(link).to_s
    end
    unless shortenURL.blank?
      self.shortenURL = Addressable::URI.heuristic_parse(shortenURL).to_s
    end
  end

  def to_adjustable?
    return if to.nil?
    if to < go_responses.count
      errors.add(:to, "현재 참석자가 설정된 모집 인원보다 많습니다. 일부 참석자를 대기자로 변경한 후 다시 시도해주세요.")
    end
  end

  def change_candidates_status
    candidates_count = to - go_responses.count
    candidates = wait_responses.order(created_at: :asc).limit(candidates_count)
    candidates.update_all(status: "go")
  end

  def fill_club_id
    self.club = self.activity.club if self.activity
  end

  def must_have_checklists
    errors.add(:task, '하나 이상의 할일이 있어야 합니다') if self.checklists.empty?
  end

  def copy_event_at_to_due_date
    self.due_date = self.event_at
  end

  def destroy_public_activities
    activities = PublicActivity::Activity.where(recipient: self)
    activities.destroy_all
  end
end
