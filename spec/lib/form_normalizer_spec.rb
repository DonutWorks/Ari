require "rails_helper"

RSpec.describe FormNormalizer do
  describe "#normalize_gender" do
    it "should skip normalize for 남/여" do
      normalized_male = FormNormalizer.normalize_gender("남")
      normalized_female = FormNormalizer.normalize_gender("여")

      expect(normalized_male).to eq("남")
      expect(normalized_female).to eq("여")
    end

    it "should normalize 남자/여자 to 남/여" do
      normalized_male = FormNormalizer.normalize_gender("남자")
      normalized_female = FormNormalizer.normalize_gender("여자")

      expect(normalized_male).to eq("남")
      expect(normalized_female).to eq("여")
    end

    it "should normalize correct though there are trailing spaces" do
      ["남 자", "남자 ", " 남"].each do |term|
        normalized_term = FormNormalizer.normalize_gender(term)
        expect(normalized_term).to eq("남")
      end
    end
  end

  describe "#normalize_phone_number" do
    it "should remove non-digit characters" do
      normalized_number = FormNormalizer.normalize_phone_number("0 1 0-1234.1234")
      expect(normalized_number).to eq("01012341234")
    end

    it "should localize international format number" do
      normalized_number = FormNormalizer.normalize_phone_number("+821012341234")
      expect(normalized_number).to eq("01012341234")
    end

    it "should return inputted number if fails parsing" do
      normalized_number = FormNormalizer.normalize_phone_number("1234")
      expect(normalized_number).to eq("1234")
    end
  end
end