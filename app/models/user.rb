class User < ActiveRecord::Base
  has_one :account_activation, dependent: :destroy
  has_many :responses
  has_many :message_histories
  has_many :messages, through: :message_histories

  scope :generation_sorted_desc, -> { order(generation_id: :desc) }

  scope :responsed_to_notice, -> (notice) { joins(:responses).merge(Response.where(notice: notice)) }
  scope :responsed_yes, -> (notice) { responsed_to_notice(notice).merge(Response.where(status: "yes")) }
  scope :responsed_maybe, -> (notice) { responsed_to_notice(notice).merge(Response.where(status: "maybe")) }
  scope :responsed_no, -> (notice) { responsed_to_notice(notice).merge(Response.where(status: "no")) }

  validates_presence_of :username, :phone_number, :email
  validates_uniqueness_of :phone_number, :email

  before_validation :normalize_phone_number
  before_save :strip!

  scope :order_by_gid, -> {order(generation_id: :desc)}
  scope :order_by_responsed_at, -> {order('responses.created_at DESC')}
  # scope :order_by_read_at, -> {joins(<<-SQL
  #   LEFT OUTER JOIN read_activity_marks as A
  #   ON A.reader_id = users.
  #   SQL
  #   ).order('read_activity_marks.created_at')}

  acts_as_reader
  scope :order_by_read_at, -> {order('read_activity_marks.created_at DESC')}

  def responsed_to?(notice)
    responses.where(notice: notice).exists?
  end

  def activated?
    return false unless account_activation
    account_activation.activated
  end

  def strip!
    strip_to = [:username, :email, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :birth ]
    strip_to.each{|column| self[column].strip! if self[column]}
  end

private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    begin
      self.phone_number = normalizer.normalize(phone_number) if !phone_number.blank?
    rescue FormNormalizers::NormalizeError => e
      errors.add(:phone_number, "가 잘못되었습니다.")
    end
  end
end