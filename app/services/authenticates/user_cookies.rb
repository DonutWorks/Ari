module Authenticates
  class UserCookies
    [:user_id, :regard_as_activated].each do |key|
      # cookies getter
      define_method("#{key.to_s}") do
        @cookies.signed[key]
      end

      # cookies setter
      define_method("#{key.to_s}=") do |value|
        @cookies.permanent.signed[key] = value
      end
    end

    def initialize(cookies)
      @cookies = cookies
    end

    def create!(user, regard_as_activated = false)
      self.user_id = user.id
      self.regard_as_activated = regard_as_activated
      return self
    end

    def destroy!
      self.user_id = nil
      self.regard_as_activated = nil
      return self
    end

    def user
      return @user if @user
      @user = User.find_by_id(user_id)
      @user.regard_as_activated = regard_as_activated if @user
      return @user
    end
  end
end