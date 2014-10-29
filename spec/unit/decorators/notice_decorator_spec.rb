require 'rails_helper'

RSpec.describe NoticeDecorator, type: :decorator do

  describe "#pretty_created_at" do
    it "displays created time as localtime with fixed format" do
      notice = FactoryGirl.build(:notice)
      notice.created_at = "1990-03-16 22:00:00 UTC"
      expect( notice.decorate.pretty_created_at).to eq("1990-03-17 07:00:00")

    end

  end

  describe "#pretty_due_date" do
    it "displays due time as localtime with fixed format" do
      notice = FactoryGirl.build(:notice)
      notice.due_date = "1990-03-16 22:00:00 UTC"
      expect( notice.decorate.pretty_due_date).to eq("1990-03-17 07:00:00")

    end

  end

  describe "#survey_due_date" do
    it "displays created time as localtime with fixed format" do
      notice = FactoryGirl.build(:notice)
      notice.due_date = "1990-03-16 22:00:00 UTC"
      expect( notice.decorate.survey_due_date).to eq("1990-03-14 07:00:00")

    end

  end

end
