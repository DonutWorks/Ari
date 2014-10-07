require "net/http"
require "addressable/uri"

class SendSMS

  class SendSMSError < RuntimeError
    attr_accessor :response
    def initialize(response)
      @response = response
    end
  end

  # should be replaced to real api
  # API_REQUEST_URL = "http://api.openapi.io/ppurio/1/message/sms/yhoonkim"
  # CLIENT_KEY = "MTg1NS0xNDExNzgxMjg0NTAyLTgwYzMwNTVjLTFkYzktNDM0Mi04MzA1LTVjMWRjOTAzNDJmMw=="

  API_REQUEST_URL = "http://api.coolsms.co.kr/sendmsg"


  def send_sms!(sms_info)
    res = Net::HTTP.get_response(generate_request_url(sms_info))

    response = {}
    res.body.scan /([\w\-]+)\=(\w+)\n/ do |key, val|
      response[key] = val
    end

    return response if response["RESULT-CODE"] == "00"
    raise SendSMSError.new(response), "문자메시지 발송에 실패하였습니다."

  end

  def send_sms(sms_info)
    begin
      send_sms!(sms_info)
      true
    rescue SendSMSError => e
      false
      # e.message
    end
  end

  def generate_request_url(sms_info)

    uri = URI(API_REQUEST_URL)
    uri.query = URI.encode_www_form(sms_info)
    uri

  end

end
