require "rails_helper"

RSpec.describe User, :type => :model do
  it "should remove dashes in phone_number before save" do
    user = FactoryGirl.build(:user)
    user.phone_number = "010-1234-1234"
    user.save!

    expect(user.phone_number).to eq("01012341234")

    user.phone_number = "010-123-1234"
    user.save!

    expect(user.phone_number).to eq("0101231234")
  end

  describe "#responsed_to?" do
    it "should return whether users responsed to notice" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      expect(user.responsed_to?(notice)).to eq(false)

      response = Response.create!(user: user, notice: notice, status: "yes")
      expect(user.responsed_to?(notice)).to eq(true)
    end
  end
end