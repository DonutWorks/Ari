require 'rails_helper'

RSpec.describe MessageDecorator, type: :decorator do


  describe "#created_at" do
    it "displays created time as localtime with fixed format" do
      message = FactoryGirl.build(:message)
      message.created_at = "1990-03-16 22:00:00 UTC"
      expect( message.decorate.created_at).to eq("1990-03-17 07:00:00")

    end

  end


end
