require "rails_helper"

RSpec.describe Gate, :type => :model do
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


