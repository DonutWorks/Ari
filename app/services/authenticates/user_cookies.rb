module Authenticates
  class UserCookies < UserStorage
    UserStorage::KEYS.each do |key|
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
  end
end