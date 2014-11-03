require "rails_helper"

RSpec.describe Response, :type => :model do
  it "should check validation" do
    expect(Response.new.save).to eq(false)
    expect(Response.new(status: "false", notice: FactoryGirl.create(:notice)).save).to eq(false)

    expect(Response.new(status: "yes", notice: FactoryGirl.create(:notice)).save).to eq(true)
    expect(Response.new(status: "maybe", notice: FactoryGirl.create(:notice)).save).to eq(true)
    expect(Response.new(status: "no", notice: FactoryGirl.create(:notice)).save).to eq(true)
    expect(Response.new(status: "go", notice: FactoryGirl.create(:notice)).save).to eq(true)
    expect(Response.new(status: "wait", notice: FactoryGirl.create(:notice)).save).to eq(true)
  end

  describe "#responsed_to_go" do
    it "should return responsed to go" do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      response1 = Response.create!(user: user1, notice: notice, status: "maybe")
      expect(Response.responsed_to_go(notice)).to be_empty

      response2 = Response.create!(user: user2, notice: notice, status: "go")
      expect(Response.responsed_to_go(notice)).to contain_exactly(response2)
    end
  end

  describe "#responsed_at" do
    it "should return created_at with localtime manner" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      response = Response.create!(user: user, notice: notice, status: "maybe", created_at: Date.new(2014, 10, 30))
      expect(response.responsed_at).to eq("2014-10-30 00:00:00")
    end
  end

  describe ".time" do
    it "should return responsed time to given notice" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      expect(user.responses.time(notice)).to eq("")

      response = Response.create!(user: user, notice: notice, status: "maybe", created_at: Date.new(2014, 10, 30))
      expect(user.responses.time(notice)).to eq("2014-10-30 00:00:00")
    end
  end
end