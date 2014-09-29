require "rails_helper"
require "net/http"

RSpec.describe SendSMS do
  describe "#send_sms" do

    sms_info = {
      from: "01054450754",
      to: "01054450754",
      user: "USERID",
      password: "PASSWORD",
      text: "TEST"
    }

    it "should send SMS" do
      sms_sender = SendSMS.new

      request_url = sms_sender.generate_request_url(sms_info)
      body = "RESULT-CODE=00\n"

      FakeWeb.register_uri(:get, request_url, :body => body)

      result = sms_sender.send_sms(sms_info)

      expect(result).to eq(true)
    end

    it "should fail to send SMS" do
      sms_sender = SendSMS.new

      request_url = sms_sender.generate_request_url(sms_info)
      body = "RESULT-CODE=20\n"

      FakeWeb.register_uri(:get, request_url, :body => body)

      sms_sender = SendSMS.new

      result = sms_sender.send_sms(sms_info)

      expect(result).to eq(false)
    end
  end
end