require "rails_helper"

RSpec.describe Authenticates::UserStorage do
  class CustomUserStorage < Authenticates::UserStorage
    KEYS.each do |key|
      define_method("#{key.to_s}") do
        @storage[key]
      end

      define_method("#{key.to_s}=") do |value|
        @storage[key] = value
      end

      def initialize(storage)
        @storage = storage
      end
    end
  end

  before(:each) do
    @storage = {}
    @user = FactoryGirl.create(:user)
  end

  describe "#create!" do
    it "should create a user storage" do
      CustomUserStorage.new(@storage).create!(@user, true)

      expect(@storage[:user_id]).to eq(@user.id)
      expect(@storage[:regard_as_activated]).to eq(true)
    end
  end

  describe "#destroy!" do
    it "should destroy a user storage" do
      user_storage = CustomUserStorage.new(@storage)
      user_storage.create!(@user, true)
      expect(@storage.empty?).to eq(false)

      user_storage.destroy!
      expect(@storage.compact.empty?).to eq(true)
    end
  end

  describe "#user" do
    it "should return a user in storage" do
      user_storage = CustomUserStorage.new(@storage)
      user_storage.create!(@user, true)

      expect(user_storage.user).to eq(@user)
    end

    it "should return a user with regard_as_activated" do
      expect(@user.regard_as_activated).to eq(nil)

      user_storage = CustomUserStorage.new(@storage)
      user_storage.create!(@user, true)

      expect(user_storage.user.regard_as_activated).to eq(true)
    end

    it "should nil when not found user" do
      user_storage = CustomUserStorage.new(@storage)
      user = @user.dup
      user.id = -1
      user_storage.create!(user, true)

      expect(user_storage.user).to eq(nil)
    end
  end
end