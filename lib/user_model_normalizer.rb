class UserModelNormalizer
  class NormalizeError < RuntimeError
    attr_accessor :user
    def initialize(user)
      @user = user
    end
  end

  def self.normalize(normalizer, data, i)
    user = User.new

    begin
      user.generation_id = normalizer.normalize(data.cell(1, 1), data.cell(i, 1))
      user.major = data.cell(i, 2)
      user.student_id = data.cell(i, 3)
      user.sex = normalizer.normalize(data.cell(1, 4), data.cell(i, 4))
      user.username = data.cell(i, 5)
      user.home_phone_number = normalizer.normalize(data.cell(1, 6), data.cell(i, 6))
      user.phone_number = normalizer.normalize(data.cell(1, 7), data.cell(i, 7))
      user.emergency_phone_number = normalizer.normalize(data.cell(1, 8), data.cell(i, 8))
      user.email = normalizer.normalize(data.cell(1, 9), data.cell(i, 9))
      user.habitat_id = data.cell(i, 10)
      user.member_type = data.cell(i, 11)
    rescue FormNormalizers::NormalizeError => e
      raise NormalizeError.new(user), e.message
    end

    user
  end
end