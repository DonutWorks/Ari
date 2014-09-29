require "rails_helper"

RSpec.describe Message, :type => :model do
  it "should associate between user and message successfully" do
    user = FactoryGirl.build(:user)
    user.save

    user.message.create(text: "hihi")

    expect(user.message.size).to eq(1)
    expect(user.message[0].text).to eq("hihi")


    user.message.create(text: "good")
    expect(user.message.size).to eq(2)

    m = Message.where(text: "hihi").first

    expect(m.user.size).to eq(1)
    expect(m.user[0]).to eq(user)

    user2 = User.new(username: "testtt", phone_number: "01000000000", email: "test@test.com")

    m.user.push user2

    expect(m.user.size).to eq(2)
    expect(m.user[1]).to eq(user2)
  end
end