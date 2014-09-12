require 'addressable/uri'

class Gate < ActiveRecord::Base
  acts_as_readable on: :created_at
  before_save :make_redirectable_url!

  def read_users
    User.joins(:read_marks).where(read_marks: {readable: self})
  end

  def unread_users
    User.joins("LEFT OUTER JOIN (SELECT * FROM read_marks WHERE readable_id = #{self.id}) AS gate_reads ON gate_reads.user_id = users.id").where('gate_reads.user_id IS NULL')
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
end
