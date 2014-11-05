require "rails_helper"

RSpec.describe Admin::Messages::SendMessageService do
  before(:each) do
    @content = "Hello, World!"
    @notice = FactoryGirl.create(:notice)
    @user_list = FactoryGirl.create_list(:user, 3)

    @sms_info = nil
    allow_any_instance_of(SMSSender).to receive(:send_sms) do |sender, info|
      @sms_info = info
    end
  end

  it "should create a message sent history for only valid user id" do
    out = Admin::Messages::SendMessageService.new.execute(@content, @notice.id, @user_list.map(&:id) + [-1])

    expect(out[:status]).to eq(:success)

    message = out[:message]
    expect(@notice.messages).to include(message)

    actual_sent = @user_list.map(&:id)
    expect_sent = message.message_histories.pluck(:user_id)
    expect(expect_sent).to eq(actual_sent)
  end

  it "should send sms to users" do
    out = Admin::Messages::SendMessageService.new.execute(@content, @notice.id, @user_list.map(&:id))

    expect(out[:status]).to eq(:success)

    expect(@sms_info[:text]).to eq(@content)
    expect(@sms_info[:to].split(",")).to eq(@user_list.map(&:phone_number))
  end

  it "should fail if notice is invalid" do

    skip "Admin can send messages without notice now."
    out = Admin::Messages::SendMessageService.new.execute(@content, -1, @user_list.map(&:id))


    expect(out[:status]).to eq(:failure)
  end
end