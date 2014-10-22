require "net/http"
require "addressable/uri"
require 'json'

class SMSSender

  class SMSSenderError < RuntimeError
    attr_accessor :response
    def initialize(response)
      @response = response
    end
  end

  API_REQUEST_URL = "https://api.coolsms.co.kr/1/send"
  API_KEY = "NCS54294848CC6D2"
  API_SECRET = "B9A97FBE326BB30545746123B67B1A65"

  def send_sms!(sms_info)

    uri = URI(API_REQUEST_URL)
    req = Net::HTTP::Post.new(uri)

    req.set_form_data(sms_info.merge(generate_authentication))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)
    response = JSON.parse(res.body)


    return response if response["result_code"] == "00"
    raise SMSSenderError.new(response), "문자메시지 발송에 실패하였습니다."

  end

  def send_sms(sms_info)
    begin
      send_sms!(sms_info)
      true
    rescue SMSSenderError => e
      false
    end
  end

  def generate_authentication
    timestamp = Time.now.to_i.to_s
    salt = (0...8).map { (65 + rand(26)).chr }.join
    hmac_data = timestamp + salt
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('md5'), API_SECRET, hmac_data)
    authentication = {
      timestamp: timestamp,
      salt: salt,
      signature: signature,
      api_key: API_KEY
    }

    authentication

  end

end
