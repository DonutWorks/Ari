require "rails_helper"
require "net/http"

RSpec.describe SendSMS do
  describe "#send_sms" do
    it "should send SMS" do
      sms_sender = SendSMS.new

      result = sms_sender.send_sms("01054450754", "01054450754", "test");

      expect(result["result_code"]).to eq("200")
    end
  end
end