require "rails_helper"

RSpec.describe FormNormalizers::Normalizer do
  describe ".normalize" do
    it "should return term not modified" do
      normalized = FormNormalizers::Normalizer.normalize("Hello")
      expect(normalized).to eq("Hello")
    end
  end
end