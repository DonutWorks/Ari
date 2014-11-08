require "rails_helper"

RSpec.describe Admin::Messages::SendMessageService do
  before(:each) do
    @club = FactoryGirl.create(:club, :with_representive, :with_club_members, :with_notices)
    @content = "Hello, World!"
    @notice = @club.notices.first
    @representive = @club.representive

    @sms_info = nil
    allow_any_instance_of(SMSSender).to receive(:send_sms) do |sender, info|
      @sms_info = info
    end
  end

  it "should create a message sent history for only valid user id" do
    out = Admin::Messages::SendMessageService.new(@club).execute(@content, @notice.id, @club.users.map(&:id) + [-1])

    expect(out[:status]).to eq(:success)

    message = out[:message]
    expect(@notice.messages).to include(message)

    actual_sent = @club.users.map(&:id)
    expect_sent = message.message_histories.pluck(:user_id)
    expect(expect_sent).to eq(actual_sent)
  end

  it "should send sms to users w/ representive phone number" do
    out = Admin::Messages::SendMessageService.new(@club).execute(@content, @notice.id, @club.users.map(&:id))

    expect(out[:status]).to eq(:success)

    expect(@sms_info[:from]).to eq(@representive.phone_number)
    expect(@sms_info[:text]).to eq(@content)
    expect(@sms_info[:to].split(",")).to eq(@club.users.map(&:phone_number))
  end

  it "should fail if notice is invalid" do
    skip "Admin can send messages without notice now."
    out = Admin::Messages::SendMessageService.new(@club).execute(@content, -1, @club.users.map(&:id))

    expect(out[:status]).to eq(:failure)
  end
end