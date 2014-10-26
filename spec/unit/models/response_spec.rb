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
end