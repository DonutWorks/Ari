require "rails_helper"

RSpec.describe FormNormalizers::Normalizer do
  before(:each) do
    @normalizer = FormNormalizers::Normalizer.new
  end

  describe ".normalize" do
    it "should return term not modified" do
      normalized = @normalizer.normalize("Hello")
      expect(normalized).to eq("Hello")
    end
  end
end