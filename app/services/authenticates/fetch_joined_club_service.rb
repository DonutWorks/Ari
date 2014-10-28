module Authenticates
  class FetchJoinedClubService < BaseService
    def execute(phone_number)
      normalizer = FormNormalizers::PhoneNumberNormalizer.new

      begin
        phone_number = normalizer.normalize(phone_number)
      rescue FormNormalizers::NormalizeError => e
        return invalid_phone_number
      end

      joined_clubs = User.where(phone_number: phone_number).pluck(:club_id).map do |id|
        Club.find_by(id: id)
      end
      joined_clubs.compact!

      return success({ clubs: joined_clubs })
    end

  private
    def invalid_phone_number
      failure({ status: :invalid_phone_number })
    end
  end
end