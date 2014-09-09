require "rails_helper"

RSpec.describe FormNormalizers::PhoneNumberNormalizer do
  describe ".normalize" do
    it "should remove non-digit characters" do
      normalized_number = FormNormalizers::PhoneNumberNormalizer.normalize("0 1 0-1234.1234")
      expect(normalized_number).to eq("01012341234")
    end

    it "should localize international format number" do
      normalized_number = FormNormalizers::PhoneNumberNormalizer.normalize("+821012341234")
      expect(normalized_number).to eq("01012341234")
    end

    it "should return inputted number if fails parsing" do
      normalized_number = FormNormalizers::PhoneNumberNormalizer.normalize("1234")
      expect(normalized_number).to eq("1234")
    end
  end
end