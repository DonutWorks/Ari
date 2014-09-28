require "rails_helper"
require "net/http"
require "addressable/uri"

class SendSMS

  # should be replaced to real api
  # API_REQUEST_URL = "http://api.openapi.io/ppurio/1/message/sms/yhoonkim"
  # CLIENT_KEY = "MTg1NS0xNDExNzgxMjg0NTAyLTgwYzMwNTVjLTFkYzktNDM0Mi04MzA1LTVjMWRjOTAzNDJmMw=="

  API_REQUEST_URL = "http://api.openapi.io/ppurio_test/1/message_test/sms/yhoonkim"
  CLIENT_KEY = "MS0xMzY1NjY2MTAyNDk0LTA2MWE4ZDgyLTZhZmMtNGU5OS05YThkLTgyNmFmYzVlOTkzZQ=="
  CONTENT_TYPE = "application/x-www-form-urlencoded"

  def send_sms(send_phone, dest_phone, msg_body)
    uri = URI.parse(API_REQUEST_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false

    request = create_api_request(uri, send_phone, dest_phone, msg_body)
    response = request_api_call(request, http)

    result = JSON.parse(response.body.to_s)
    result
  end

private
  def create_api_request(uri, send_phone, dest_phone, msg_body)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => CONTENT_TYPE})
    request['x-waple-authorization'] = CLIENT_KEY;

    uri = Addressable::URI.new
    uri.query_values = { send_phone: "#{send_phone}", dest_phone: "#{dest_phone}", msg_body: "#{msg_body}" }
    request.body = uri.query

    request
  end

  def request_api_call(request, http)
    http.request(request)
  end

end