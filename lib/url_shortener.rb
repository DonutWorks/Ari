class URLShortener
  API_KEY = "AIzaSyBawrZ6u8uOTYieaoikGhqFXWibg5XJsq4".freeze

  def initialize(request = nil)
    @request = request
  end

  def shorten_url(url)
    if @request
      result = Googl.shorten(url, @request.remote_ip, API_KEY)
    else
      result = Googl.shorten(url)
    end

    result.short_url
  end
end