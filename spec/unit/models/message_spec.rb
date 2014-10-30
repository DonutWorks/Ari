require "rails_helper"

RSpec.describe Message, :type => :model do
  describe 'validation check' do
    it "should check presence validation for content" do
      expect(Message.new.save).to eq(false)

      expect(Message.new(content: "hi").save).to eq(true)
    end
  end

  describe "#created_at_sorted_desc" do
    it "should descending by created_at" do
      now = DateTime.now

      message1 = Message.create!(content: "message1", created_at: now - 1.day)
      message2 = Message.create!(content: "message2", created_at: now - 3.day)
      message3 = Message.create!(content: "message3", created_at: now - 2.day)

      expect(Message.created_at_sorted_desc).to eq([message1, message3, message2])
    end
  end
end