require "rails_helper"

RSpec.describe Message, :type => :model do
  it "should associate between user and message successfully" do
    user = FactoryGirl.build(:user)
    user.save

    user.messages.create(content: "hihi")

    expect(user.messages.size).to eq(1)
    expect(user.messages[0].content).to eq("hihi")


    user.messages.create(content: "good")
    expect(user.messages.size).to eq(2)

    m = Message.where(content: "hihi").first

    expect(m.users.size).to eq(1)
    expect(m.users[0]).to eq(user)

    user2 = User.new(username: "testtt", phone_number: "01000000000", email: "test@test.com")

    m.users.push user2

    expect(m.users.size).to eq(2)
    expect(m.users[1]).to eq(user2)
  end

  it "should check validation" do
    expect(Message.new.save).to eq(false)

    expect(Message.new(content: "hi").save).to eq(true)    
  end

  it "should use correct scope" do
    10.times {
        Message.create(content: Random.rand(10).to_s)
    }

    expect(Message.created_at_sorted_desc).to eq(Message.all.order(created_at: :desc))
  end
end