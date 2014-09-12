require "rails_helper"

RSpec.describe URLShortener do
  describe "#shorten_url" do
    it "should make shorten url" do
      shortener = URLShortener.new

      allow(shortener).to receive(:request_api_call) do
        OpenStruct.new({
          body: {
            id: "http://goo.gl/fake_url"
          }.to_json
        })
      end

      shorten_url = shortener.shorten_url("http://google.com")
      expect(shorten_url).to eq("http://goo.gl/fake_url")
    end
  end
end