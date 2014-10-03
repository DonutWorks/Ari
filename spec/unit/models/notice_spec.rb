require "rails_helper"

RSpec.describe Notice, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      notice = FactoryGirl.create(:notice, link: "www.google.com", shortenURL: "www.google.com")

      expect(notice.link).to eq('http://www.google.com')
      expect(notice.shortenURL).to eq('http://www.google.com')
    end
  end
end


