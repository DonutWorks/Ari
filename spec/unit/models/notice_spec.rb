require "rails_helper"

RSpec.describe Notice, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      notice = FactoryGirl.create(:notice, link: "www.google.com", shortenURL: "www.google.com")

      expect(notice.link).to eq('http://www.google.com')
      expect(notice.shortenURL).to eq('http://www.google.com')
    end
  end

  describe "#to_adjustable?" do
    before(:each) do
      @to_notice = FactoryGirl.create(:to_notice, to: 3)
      @users = FactoryGirl.create_list(:user, 2)
    end

    it "should raise an error when inputted TO is less than the number of responsed go" do
      expect(@to_notice.go_responses.count).to eq(0)

      @users.each do |user|
        Response.create!(user: user, notice: @to_notice, status: "go")
      end
      expect(@to_notice.go_responses.count).to eq(2)

      @to_notice.to = 1
      expect { @to_notice.save! }.to raise_error
    end

    it "should update when inputted TO is greater than the number of responsed go" do
      @to_notice.to = 2
      expect { @to_notice.save! }.not_to raise_error
    end
  end
end


