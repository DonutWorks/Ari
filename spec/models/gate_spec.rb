require "rails_helper"

RSpec.describe Gate, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      gate = Gate.new
      gate.link = 'www.google.com'
      gate.shortenURL = 'www.google.com'

      expect(gate.save).to eq(true)
      expect(gate.link).to eq('http://www.google.com')
      expect(gate.shortenURL).to eq('http://www.google.com')
    end
  end

  describe "#make_shortenURL" do
    it "should make shorten url" do
      gate = Gate.new

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
end


