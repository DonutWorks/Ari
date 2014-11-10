module Authenticates
  class CookiesSignInService < BaseService
    def execute(session, cookies)
      user_cookies = UserCookies.new(cookies)
      user_from_cookies = user_cookies.user

      if user_from_cookies && user_from_cookies.club == current_club
        user_session = UserSession.new(session)
        user_session.create!(user_from_cookies, user_from_cookies.regard_as_activated)
        return success
      end

      user_cookies.destroy!
      return failure
    end
  end
end