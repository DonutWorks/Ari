require "rails_helper"

RSpec.describe AssigneeComment, :type => :model do
  context "when check validations" do
    before(:each) do
      @assignee_comment = AssigneeComment.new
      @assignee_comment.valid?
    end

    it "should check validation for comment" do
      expect(@assignee_comment.errors.messages.keys).to be_include(:comment)
    end
  end
end