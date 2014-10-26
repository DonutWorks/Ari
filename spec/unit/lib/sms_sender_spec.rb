require "rails_helper"
require "net/http"

RSpec.describe SMSSender do
  describe "#send_sms" do

    sms_info = {
      from: "01054450754",
      to: "01054450754,01032325374", #최대 1000명에게 동시에 요청 보낼 수 있다.
      text: "TEST"
    }

    it "should send SMS" do
      sms_sender = SMSSender.new

      request_url = "https://api.coolsms.co.kr/1/send"
      body = '{"result_code":"00"}'
      FakeWeb.register_uri(:post, request_url, :body => body)

      result = sms_sender.send_sms(sms_info)

      expect(result).to eq(true)
    end

    it "should fail to send SMS" do
      sms_sender = SMSSender.new

      request_url = "https://api.coolsms.co.kr/1/send"
      body = '{"result_code":"20"}'
      FakeWeb.register_uri(:post, request_url, :body => body)

      result = sms_sender.send_sms(sms_info)

      expect(result).to eq(false)
    end

  end

end