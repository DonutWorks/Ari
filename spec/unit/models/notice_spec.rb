require "rails_helper"

RSpec.describe Notice, :type => :model do
  describe "#[NOTICE_TYPES]_notice?" do
    it "should return whether notice is given type" do
      given_type = Notice::NOTICE_TYPES.first
      notice = FactoryGirl.create(:notice, notice_type: given_type)

      expect(notice.send("#{given_type}_notice?")).to eq(true)
      Notice::NOTICE_TYPES[1..-1].each do |type|
        expect(notice.send("#{type}_notice?")).to eq(false)
      end
    end
  end

  describe "#[Response::STATUSES]_responses" do
    it "should return responses that is given status" do
      user = FactoryGirl.create(:user)
      notice = FactoryGirl.create(:notice)

      given_status = Response::STATUSES.first
      expect(notice.send("#{given_status}_responses").empty?).to eq(true)

      response = Response.create!(user: user, notice: notice, status: given_status)
      expect(notice.send("#{given_status}_responses")).to match_array([response])

      Response::STATUSES[1..-1].each do |status|
        expect(notice.send("#{status}_responses").empty?).to eq(true)
      end
    end
  end

  describe "#save with make_redirectable_url!" do
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
      expect(@to_notice).not_to be_valid
    end

    it "should update when inputted TO is greater than the number of responsed go" do
      @to_notice.to = 2
      expect(@to_notice).to be_valid
    end
  end

  describe "#change_candidates_status" do
    before(:each) do
      @to_notice = FactoryGirl.create(:to_notice, to: 1)
    end

    it "should change waiting user to going user when TO is increased" do
      @going_users = FactoryGirl.create_list(:user, 1)
      @waiting_users = FactoryGirl.create_list(:user, 2)

      @going_users.each do |user|
        Response.create!(user: user, notice: @to_notice, status: "go")
      end

      # reverse, test for created_at asc.
      @waiting_users.reverse.each do |user|
        Response.create!(user: user, notice: @to_notice, status: "wait")
      end

      expect(@to_notice.go_responses.count).to eq(1)

      @to_notice.to = 2
      expect(@to_notice).to be_valid
      @to_notice.save!

      expect(@to_notice.go_responses.count).to eq(2)
      expect(@to_notice.wait_responses.count).to eq(1)

      wait_response = @to_notice.wait_responses.first
      @to_notice.go_responses.each do |go_response|
        expect(go_response.created_at).to be <= wait_response.created_at
      end

      expect(wait_response.user).to eq(@waiting_users.first)
    end
  end

  describe "check validation" do
    it "should check presence validation for title" do
      expect(Notice.new.save).to eq(false)
      expect(FactoryGirl.build(:notice, title: "").save).to eq(false)
    end

    it "should check presence validation for link if external?" do
      expect(Notice.new.save).to eq(false)
      expect(FactoryGirl.build(:notice, link: "", notice_type: 'external').save).to eq(false)

      expect(FactoryGirl.build(:notice, link: "www.naver.com", notice_type: 'external').save).to eq(true)
      expect(FactoryGirl.build(:notice, link: "", notice_type: 'plain').save).to eq(true)
      expect(FactoryGirl.build(:notice, link: "", notice_type: 'survey').save).to eq(true)
      expect(FactoryGirl.build(:notice, link: "", notice_type: 'to', to: 2).save).to eq(true)
    end

    it "should check presence validation for content" do
      expect(Notice.new.save).to eq(false)
      expect(FactoryGirl.build(:notice, content: "").save).to eq(false)
    end

    it "should check presence validation for notice_type" do
      expect(Notice.new.save).to eq(false)
      expect(FactoryGirl.build(:notice, notice_type: "").save).to eq(false)
      expect(FactoryGirl.build(:notice, notice_type: "none").save).to eq(false)
    end

    it "should check numericality validation for to" do
      expect(Notice.new.save).to eq(false)
      expect(FactoryGirl.build(:notice, notice_type: 'to', to: "hi").save).to eq(false)

      expect(FactoryGirl.build(:notice, notice_type: 'to', to: 2).save).to eq(true)
    end
  end
end