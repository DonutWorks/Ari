require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Admin::UsersHelper. For example:
#
# describe Admin::UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Admin::UsersHelper, :type => :helper do
  describe "#pretty_phone_number" do
    it "displays phone_number with dash(-)" do
      expect(helper.pretty_phone_number("01011112222")).to eq "010-1111-2222"
      expect(helper.pretty_phone_number("0101112222")).to eq "010-111-2222"
    end

    it "displays original phone_number if contains dash(-)" do
      expect(helper.pretty_phone_number("010-1111-2222")).to eq "010-1111-2222"
      expect(helper.pretty_phone_number("010-111-2222")).to eq "010-111-2222"
    end
  end
end
