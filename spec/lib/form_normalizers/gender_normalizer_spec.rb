require "rails_helper"

RSpec.describe FormNormalizers::GenderNormalizer do
  describe ".normalize" do
    it "should skip normalize for 남/여" do
      normalized_male = FormNormalizers::GenderNormalizer.normalize("남")
      normalized_female = FormNormalizers::GenderNormalizer.normalize("여")

      expect(normalized_male).to eq("남")
      expect(normalized_female).to eq("여")
    end

    it "should normalize 남자/여자 to 남/여" do
      normalized_male = FormNormalizers::GenderNormalizer.normalize("남자")
      normalized_female = FormNormalizers::GenderNormalizer.normalize("여자")

      expect(normalized_male).to eq("남")
      expect(normalized_female).to eq("여")
    end

    it "should normalize correct though there are trailing spaces" do
      ["남 자", "남자 ", " 남"].each do |term|
        normalized_term = FormNormalizers::GenderNormalizer.normalize(term)
        expect(normalized_term).to eq("남")
      end
    end

    it "should throw an exception when normalization is failed" do
      begin
        normalized = FormNormalizers::GenderNormalizer.normalize("??")
      rescue => e
        expect(e.instance_of? FormNormalizers::NormalizeError).to eq(true)
      end
    end
  end
end