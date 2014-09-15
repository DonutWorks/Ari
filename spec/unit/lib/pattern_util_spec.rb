require "rails_helper"

RSpec.describe PatternUtil do
  PATTERN = "이름/기수/전화번호 뒤 4자리"
  COMMENT = "홍길동/3기/6087"

  describe "#count" do
    it "should count correctly by pattern" do
      pattern = PatternUtil.new(PATTERN)
      expect(pattern.count_column).to eq(3)
    end

    it "should count correctly by other comment" do
      pattern = PatternUtil.new(PATTERN)
      expect(pattern.count_column(COMMENT)).to eq(3)
    end
  end

  describe "#compare" do
    it "should match and return true" do
      pattern = PatternUtil.new(PATTERN)
      expect(pattern.compare(COMMENT)).to eq(true)
    end

    it "should not match and return false" do
      comment = "홍길동/3기6087"

      pattern = PatternUtil.new(PATTERN)
      expect(pattern.compare(comment)).to eq(false)
    end
  end

  describe "#column_names" do
    it "should return column_names" do
      pattern = PatternUtil.new(PATTERN)
      expect(pattern.column_names).to eq(["이름", "기수", "전화번호 뒤 4자리"])
    end
  end
end