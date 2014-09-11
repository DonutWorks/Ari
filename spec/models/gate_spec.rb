require "rails_helper"

RSpec.describe Gate, :type => :model do
  describe "#save" do
    it "should prepend protocol if not exist" do
      gate = Gate.new
      gate.link = 'www.google.com'
      gate.shortenURL = 'www.google.com'

      expect(gate.save).to eq(true)
      expect(gate.link).to eq('http://www.google.com')
      expect(gate.shortenURL).to eq('http://www.google.com')
    end
  end

  describe "#read_users" do
    before(:each) do
      @user = User.new
      @user.email = "test@test.com"
      @user.username = "John"
      @user.phonenumber = "01012341234"
      @user.major = "CS"
      @user.password = "testtest"
      @user.save!

      @gate = Gate.new
      @gate.save!
    end

    it "should return users who read a gate" do
      expect(@gate.read_users).to eq([])

      @gate.mark_as_read!(for: @user)
      expect(@gate.read_users).to eq([@user])
    end
  end

  describe "#not_read_users" do
    before(:each) do
      @user = User.new
      @user.email = "test@test.com"
      @user.username = "John"
      @user.phonenumber = "01012341234"
      @user.major = "CS"
      @user.password = "testtest"
      @user.save!

      @gate = Gate.new
      @gate.save!
    end

    it "should return users who don't read a gate" do
      expect(@gate.not_read_users).to eq([@user])

      @gate.mark_as_read!(for: @user)
      expect(@gate.not_read_users).to eq([])
    end
  end
end


