require "rails_helper"

RSpec.describe FormNormalizers::GenerationNormalizer do
  describe ".normalize" do
    it "should append prefix if there is no prefix" do
      normalized = FormNormalizers::GenerationNormalizer.normalize("1기")
      expect(normalized).to eq("1기")

      normalized = FormNormalizers::GenerationNormalizer.normalize("2.5기")
      expect(normalized).to eq("2.5기")

      normalized = FormNormalizers::GenerationNormalizer.normalize("3.5")
      expect(normalized).to eq("3.5기")
    end
  end
end