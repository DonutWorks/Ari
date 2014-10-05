require 'addressable/uri'

class Notice < ActiveRecord::Base
  NOTICE_TYPE = %w(external plain survey)

  acts_as_readable
  before_save :make_redirectable_url!

  validates :title, presence: { message: "공지 제목을 입력해주십시오." }
  validates :link, presence: { message: "공지 링크를 입력해주십시오." }
  validates :content, presence: { message: "공지 내용을 입력해주십시오." }
  validates :notice_type, presence: { message: "유형을 선택해주십시오." },
   inclusion: { in: NOTICE_TYPE, message: "올바르지 않은 유형입니다." }

private
  def make_redirectable_url!
    unless link.blank?
      self.link = Addressable::URI.heuristic_parse(link).to_s
    end
    unless shortenURL.blank?
      self.shortenURL = Addressable::URI.heuristic_parse(shortenURL).to_s
    end
  end
end
