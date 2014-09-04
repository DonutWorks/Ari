class Gate < ActiveRecord::Base
  acts_as_readable on: :created_at

  def make_shortenURL
    require "uri"
    require "net/http"

    uri = URI.parse("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyCPjcArjKfGKsxMfa9DPXME7peALnwpLY0")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
    request = Net::HTTP::Post.new(uri.path,{'Content-Type' =>'application/json'})
    request.body = '{"longUrl" : "'+self.link+'"}'
    response = http.request(request)
    hash = JSON.parse( response.body.to_s )
    return hash["id"]
  end

end
