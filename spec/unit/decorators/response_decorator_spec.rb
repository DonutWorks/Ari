require 'rails_helper'

RSpec.describe ResponseDecorator, type: :decorator do


  describe "#responsed_at" do
    it "displays responsed time as localtime with fixed format" do
      response = FactoryGirl.build(:response)
      response.created_at = "1990-03-16 22:00:00 UTC"
      expect( response.decorate.responsed_at).to eq("1990-03-17 07:00:00")

    end

  end


end
