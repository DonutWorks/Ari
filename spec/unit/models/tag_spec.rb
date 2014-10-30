require "rails_helper"

RSpec.describe Tag, :type => :model do
  describe "#fetch_list_by_tag_name" do
    it "should fetch tag list where like name" do
      tag1 = Tag.create!(tag_name: "Hello")
      tag2 = Tag.create!(tag_name: "World")
      tag3 = Tag.create!(tag_name: "Yellow")

      expect(Tag.fetch_list_by_tag_name("Worl")).to contain_exactly(tag2)
      expect(Tag.fetch_list_by_tag_name("llo")).to contain_exactly(tag1, tag3)
    end
  end
end