require "rails_helper"

RSpec.describe Notice, :type => :model do
  describe "#save with make_redirectable_url!" do
    it "should prepend protocol if not exist" do
      notice = FactoryGirl.create(:notice, link: "www.google.com", shortenURL: "www.google.com")

      expect(notice.link).to eq('http://www.google.com')
      expect(notice.shortenURL).to eq('http://www.google.com')
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


