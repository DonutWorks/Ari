require "rails_helper"

RSpec.describe Gate, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      gate = create(:gate, link: "www.google.com", shortenURL: "www.google.com")

      expect(gate.link).to eq('http://www.google.com')
      expect(gate.shortenURL).to eq('http://www.google.com')
    end
  end

  describe "#make_shortenURL" do
    it "should make shorten url" do
      gate = create(:gate)

      allow(gate).to receive(:request_to_google) do
        OpenStruct.new({
          body: {
            id: "http://goo.gl/fake_url"
          }.to_json
        })
      end

      shorten_url = gate.make_shortenURL("http://www.google.com/")
      expect(shorten_url).to eq("http://goo.gl/fake_url")
    end
  end

  describe "#read_users" do
    it "should return users who read a gate" do
      user = create(:user)
      gate = create(:gate)

      expect(gate.read_users).to eq([])

      gate.mark_as_read!(for: user)
      expect(gate.read_users).to eq([user])
    end
  end

  describe "#unread_users" do
    it "should return users who don't read a gate" do
      user = create(:user)
      gate = create(:gate)

      expect(gate.unread_users).to eq([user])

      gate.mark_as_read!(for: user)
      expect(gate.unread_users).to eq([])
    end
  end
end


