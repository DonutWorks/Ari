require 'addressable/uri'

class Notice < ActiveRecord::Base
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

  validates :to, numericality: { greater_than_or_equal_to: 1 }, if: :to_notice?
  validate :to_adjustable?, if: :to_notice?

  has_many :responses
  has_many :messages
  has_many :checklists
  accepts_nested_attributes_for :checklists, reject_if: lambda {|attributes| attributes['task'].blank?}

  acts_as_readable
  before_save :make_redirectable_url!
  before_save :change_candidates_status, if: :to_notice?

  validates :title, presence: true
  validates :link, presence: true, if: :external_notice?
  validates :content, presence: true
  validates :notice_type, presence: { message: "유형을 선택해주십시오." },
   inclusion: { in: NOTICE_TYPES, message: "올바르지 않은 유형입니다." }
  validate :must_have_checklists, if: :checklist_notice?


  def self.deadline_send_sms
    Notice.where(notice_type: 'to').where(due_date: Date.today + 3.days).find_each do |notice|
      Response.responsed_to_go(notice).find_each do |response|
        Admin::Messages::SendMessageService.new.execute("[" + notice.title + "] 공지의 신청이 마감 되었습니다.", notice.id, response.user.id)
      end
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

  def must_have_checklists
    errors.add(:task, '하나 이상의 체크리스트가 있어야 합니다') if self.checklists.empty?
  end
end
