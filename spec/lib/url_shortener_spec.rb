require "rails_helper"

RSpec.describe URLShortener do
  describe "#shorten_url" do
    it "should make shorten url" do
      shortener = URLShortener.new("http://google.com")

      allow(shortener).to receive(:request_api_call) do
        OpenStruct.new({
          body: {
            id: "http://goo.gl/fake_url"
          }.to_json
        })
      end

      shorten_url = shortener.shorten_url
      expect(shorten_url).to eq("http://goo.gl/fake_url")
    end

    it "should call api once for each url" do
      shortener = URLShortener.new("http://google.com")

      allow(shortener).to receive(:request_api_call) do
        OpenStruct.new({
          body: {
            id: "http://goo.gl/fake_url"
          }.to_json
        })
      end

      shorten_url = shortener.shorten_url
      expect(shorten_url).to eq("http://goo.gl/fake_url")

      allow(shortener).to receive(:request_api_call) do
        OpenStruct.new({
          body: {
            id: "http://goo.gl/fake_url2"
          }.to_json
        })
      end

      shorten_url = shortener.shorten_url
      expect(shorten_url).to eq("http://goo.gl/fake_url")
    end
  end
end