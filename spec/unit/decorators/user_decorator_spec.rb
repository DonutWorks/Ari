require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do


  describe "#phone_number" do
    it "displays phone_number with dash(-)" do
      user = FactoryGirl.build(:user)
      user.phone_number = "01012341234"

      expect(user.decorate.phone_number).to eq "010-1234-1234"
      user.phone_number = "0101231234"
      expect(user.decorate.phone_number).to eq "010-123-1234"

    end

    it "displays original phone_number if contains dash(-)" do
      user = FactoryGirl.build(:user)
      user.phone_number = "010-1234-1234"

      expect(user.decorate.phone_number).to eq "010-1234-1234"
      user.phone_number = "010-123-1234"
      expect(user.decorate.phone_number).to eq "010-123-1234"

    end
  end


end
