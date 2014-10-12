module Authenticates
  class KakaoSignInService
    def execute(session, auth_hash)
      user = User.find_by({
        provider: auth_hash['provider'],
        uid: auth_hash['uid']
      })

      if user.nil?
        return need_to_register
      end

      # update user info
      user.update_attributes!(extra_info: auth_hash['info'])

      session[:user_id] = user.id
      return success({ user: user })
    end

  private
    def need_to_register
      { status: :need_to_register }
    end

    def success(params)
      params.merge!({ status: :success })
    end
  end
end