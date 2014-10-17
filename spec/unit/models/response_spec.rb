require "rails_helper"

RSpec.describe Response, :type => :model do
  it "should check validation" do
    expect(Response.new.save).to eq(false)
    expect(Response.new(status: "false").save).to eq(false)
    
    expect(Response.new(status: "yes").save).to eq(true)
    expect(Response.new(status: "maybe").save).to eq(true)
    expect(Response.new(status: "no").save).to eq(true)
    expect(Response.new(status: "go").save).to eq(true)
    expect(Response.new(status: "wait").save).to eq(true)
  end
end