module Authenticates
  class UserSession
    [:user_id, :regard_as_activated].each do |key|
      # session getter
      define_method("#{key.to_s}") do
        @session[key]
      end

      # session setter
      define_method("#{key.to_s}=") do |value|
        @session[key] = value
      end
    end

    def initialize(session)
      @session = session
    end

    def self.create_from_user!(session, user)
      user_session = UserSession.new(session)
      user_session.create!(user, user.regard_as_activated)
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