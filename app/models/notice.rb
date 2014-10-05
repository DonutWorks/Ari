require 'addressable/uri'

class Notice < ActiveRecord::Base
  acts_as_readable
  before_save :make_redirectable_url!

  validates_presence_of :title, :message => "공지 제목을 입력해주십시오."
  validates_presence_of :link, :message => "공지 링크를 입력해주십시오."
  validates_presence_of :content, :message => "공지 내용을 입력해주십시오."

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
