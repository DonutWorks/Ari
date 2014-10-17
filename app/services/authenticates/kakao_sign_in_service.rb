module Authenticates
  class KakaoSignInService < BaseService
    def execute(session, auth_hash)
      user = User.find_by({
        provider: auth_hash['provider'],
        uid: auth_hash['uid']
      })

      if user.nil?
        return failure({ status: :need_to_register })
      end

      # update user info
      user.update_attributes!(extra_info: auth_hash['info'])

      UserSession.new(session).create!(user, false)
      return success({ user: user })
    end
  end
end