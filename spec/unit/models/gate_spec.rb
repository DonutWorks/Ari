require "rails_helper"

RSpec.describe Gate, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      gate = FactoryGirl.create(:gate, link: "www.google.com", shortenURL: "www.google.com")

      expect(gate.link).to eq('http://www.google.com')
      expect(gate.shortenURL).to eq('http://www.google.com')
    end
  end
end


