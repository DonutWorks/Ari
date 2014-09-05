require 'addressable/uri'

class Gate < ActiveRecord::Base
  acts_as_readable on: :created_at
  before_save :make_redirectable_url!

  def make_shortenURL(long_url)

    require "uri"
    require "net/http"

    uri = URI.parse("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyA5-F8Di51O7rijYgzTeT8cmK1w4QDjCT8")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 

    request = Net::HTTP::Post.new(uri.path,{'Content-Type' => 'application/json'})
    request.body = '{"longUrl" : "' + long_url + '"}'

    response = request_to_google(request, http)

    hash = JSON.parse(response.body.to_s)
    return hash["id"]
  end

  def read_users
    User.joins(:read_marks).where(read_marks: {readable: self})
  end

  def not_read_users
    User.joins("LEFT OUTER JOIN (SELECT * FROM read_marks WHERE readable_id = #{self.id}) AS gate_reads ON gate_reads.user_id = users.id").where('gate_reads.user_id IS NULL')
  end

private
  def request_to_google(request, http)
    http.request(request)
  end

  def make_redirectable_url!
    unless link.blank?
      self.link = Addressable::URI.heuristic_parse(link).to_s
    end
    unless shortenURL.blank?
      self.shortenURL = Addressable::URI.heuristic_parse(shortenURL).to_s
    end
  end
end
