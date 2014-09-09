require "rails_helper"

RSpec.describe FormNormalizer do
  describe ".normalize" do
    it "should normalize gender for some terms" do
      normalized = FormNormalizer.normalize("성별", "남 자")
      expect(normalized).to eq("남")
    end

    it "should normalize phone number for some terms" do
      normalized = FormNormalizer.normalize("휴대 전화", "010-1234-1234")
      expect(normalized).to eq("01012341234")
    end

    it "should normalize generation info for some terms" do
      normalized = FormNormalizer.normalize("기수", "4.5")
      expect(normalized).to eq("4.5기")
    end

    it "should return term not modified if there is no responding normalizer" do
      normalized = FormNormalizer.normalize("루비", "Ruby!")
      expect(normalized).to eq("Ruby!")
    end
  end
end