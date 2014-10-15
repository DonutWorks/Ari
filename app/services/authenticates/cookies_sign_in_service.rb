module Authenticates
  class CookiesSignInService < BaseService
    def execute(session, cookies)
      user_cookies = UserCookies.new(cookies)
      user_from_cookies = user_cookies.user

      if user_from_cookies
        UserSession.create_from_user!(session, user_cookies.user)
        return success
      end

      user_cookies.destroy!
      return failure
    end
  end
end