class Gate < ActiveRecord::Base
  acts_as_readable on: :created_at

  def make_shortenURL(long_url)

    require "uri"
    require "net/http"

    uri = URI.parse("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyA5-F8Di51O7rijYgzTeT8cmK1w4QDjCT8")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 

    request = Net::HTTP::Post.new(uri.path,{'Content-Type' => 'application/json'})
    request.body = '{"longUrl" : "' + long_url + '"}'

    response = http.request(request)
    response = request_to_google(request, http)

    hash = JSON.parse(response.body.to_s)
    return hash["id"]
  end

private
  def request_to_google(request, http)
    http.request(request)
  end
end
