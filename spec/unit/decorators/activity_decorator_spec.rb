
require 'rails_helper'

RSpec.describe ActivityDecorator, type: :decorator do


  describe "#event_at" do
    it "displays evented time as localtime with fixed format" do
      activity = FactoryGirl.build(:activity)
      activity.event_at = "1990-03-16 22:00:00 UTC"
      expect( activity.decorate.event_at).to eq("1990-03-17 07:00:00")

    end

  end


end
