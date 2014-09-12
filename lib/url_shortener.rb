class URLShortener
  API_REQUEST_URL = "https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyA5-F8Di51O7rijYgzTeT8cmK1w4QDjCT8"

  def shorten_url(url)
    uri = URI.parse(API_REQUEST_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = create_api_request(uri, url)
    response = request_api_call(request, http)

    result = JSON.parse(response.body.to_s)
    result["id"]
  end

private
  def create_api_request(uri, url)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = '{"longUrl" : "' + url + '"}'
    request
  end

  def request_api_call(request, http)
    http.request(request)
  end
end