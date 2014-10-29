module Authenticates
  class PhoneNumberSignInService < BaseService
    def execute(session, phone_number)
      normalizer = FormNormalizers::PhoneNumberNormalizer.new
      phone_number = normalizer.normalize(phone_number)

      user = User.find_by(phone_number: phone_number)

      if user.nil?
        return invalid_phone_number
      end

      UserSession.new(session).create!(user, true)
      return success({ user: user })

    rescue FormNormalizers::NormalizeError => e
      return failure({ status: :invalid_phone_number })
    end

  private
    def invalid_phone_number
      { status: :invalid_phone_number }
    end
  end
end