require "rails_helper"

RSpec.describe Checklist, :type => :model do
  context "when check validations" do
    before(:each) do
      @checklist = Checklist.new
      @checklist.valid?
    end

    it "should belong to club" do
      expect(@checklist.errors.messages.keys).to be_include(:club_id)
    end

    it "should check validation for task" do
      expect(@checklist.errors.messages.keys).to be_include(:task)
    end

    it "should check validation for #must_has_assignees" do
      expect(@checklist.errors.messages.keys).to be_include(:assignees)
    end
  end
end