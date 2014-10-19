module Authenticates
  class UserSession < UserStorage
    UserStorage::KEYS.each do |key|
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
  end
end