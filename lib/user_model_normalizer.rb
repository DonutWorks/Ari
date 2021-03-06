class UserModelNormalizer
  class NormalizeError < RuntimeError
    attr_accessor :user
    def initialize(user)
      @user = user
    end
  end

  def self.normalize(normalizer, data, i)
    user = User.new

    user.generation_id = normalizer.normalize(data.cell(1, 1), data.cell(i, 1))
    user.major = data.cell(i, 2).strip
    user.student_id = data.cell(i, 3).strip
    user.sex = normalizer.normalize(data.cell(1, 4), data.cell(i, 4))
    user.username = data.cell(i, 5).strip
    user.birth = normalizer.normalize(data.cell(1, 6), data.cell(i, 6))
    user.home_phone_number = normalizer.normalize(data.cell(1, 7), data.cell(i, 7))
    user.phone_number = normalizer.normalize(data.cell(1, 8), data.cell(i, 8))
    user.emergency_phone_number = normalizer.normalize(data.cell(1, 9), data.cell(i, 9))
    user.email = normalizer.normalize(data.cell(1, 10), data.cell(i, 10))
    user.habitat_id = data.cell(i, 11).strip
    user.member_type = data.cell(i, 12).strip

    user

  rescue FormNormalizers::NormalizeError => e
    raise NormalizeError.new(user), e.message
  end
end