require "rails_helper"

RSpec.describe FormNormalizers::GenerationNormalizer do
  before(:each) do
    @normalizer = FormNormalizers::GenerationNormalizer.new
  end

  describe ".normalize" do
    it "should append prefix if there is no prefix" do
      normalized = @normalizer.normalize("1기")
      expect(normalized).to eq("1")

      normalized = @normalizer.normalize("2.5기")
      expect(normalized).to eq("2.5")

      normalized = @normalizer.normalize("3.5")
      expect(normalized).to eq("3.5")
    end
  end

  it "should throw an exception when normalization is failed" do
    begin
      normalized = @normalizer.normalize("??")
    rescue => e
      expect(e.instance_of? FormNormalizers::NormalizeError).to eq(true)
    end
  end
end