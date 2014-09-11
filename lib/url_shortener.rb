class URLShortener
  API_REQUEST_URL = "https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyA5-F8Di51O7rijYgzTeT8cmK1w4QDjCT8"
  def initialize(url)
    @url = url
  end

  def shorten_url
    @shorten_url || shorten
  end

private
  def shorten
    uri = URI.parse(API_REQUEST_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = create_api_request(uri)
    response = request_api_call(request, http)

    result = JSON.parse(response.body.to_s)
    @shorten_url = result["id"]
  end

  def create_api_request(uri)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = '{"longUrl" : "' + @url + '"}'
    return request
  end

  def request_api_call(request, http)
    http.request(request)
  end
end