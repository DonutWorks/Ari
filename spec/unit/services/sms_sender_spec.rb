require "rails_helper"

RSpec.describe SmsSender do

  describe "#send_message"
  it "should be send SMS to Users" do
    user = FactoryGirl.build(:user)
    user.phone_number = "010-5445-0754"
    user.save!

    user2 = FactoryGirl.build(:user)
    user2.username = "Tom"
    user2.email = "tom@donutworks.com"
    user2.phone_number = "010-3232-5374"
    user2.save!

    notice = FactoryGirl.build(:notice)
    notice.save!

    #to be sure, test it without fakeweb
    request_url = "https://api.coolsms.co.kr/1/send"
    body = '{"result_code":"00"}'
    FakeWeb.register_uri(:post, request_url, :body => body)

    sms_sender = SmsSender.new
    message = sms_sender.send_message("Service, SmsSender Test", notice.id, [user.id, user2.id])

    expect(message.nil?).to eq(false)

  end
end