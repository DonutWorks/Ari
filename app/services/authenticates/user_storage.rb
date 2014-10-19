module Authenticates
  class UserStorage
    KEYS = [:user_id, :regard_as_activated]
    KEYS.each do |key|
      define_method("#{key.to_s}") do
        raise "need to implement getter."
      end

      define_method("#{key.to_s}=") do |value|
        raise "need to implement setter."
      end
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