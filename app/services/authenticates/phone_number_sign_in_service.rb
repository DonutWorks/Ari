module Authenticates
  class PhoneNumberSignInService
    def execute(session, phone_number)
      normalizer = FormNormalizers::PhoneNumberNormalizer.new

      begin
        phone_number = normalizer.normalize(phone_number)
      rescue FormNormalizers::NormalizeError => e
        return invalid_phone_number
      end

      user = User.find_by(phone_number: phone_number)

      if user.nil?
        return invalid_phone_number
      end

      session[:user_id] = user.id
      return success({ user: user })
    end

  private
    def invalid_phone_number
      { status: :invalid_phone_number }
    end

    def success(params)
      params.merge!({ status: :success })
    end
  end
end