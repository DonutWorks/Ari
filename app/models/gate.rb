require 'addressable/uri'

class Gate < ActiveRecord::Base
  acts_as_readable
  before_save :make_redirectable_url!

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
