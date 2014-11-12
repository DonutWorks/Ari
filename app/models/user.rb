class User < ActiveRecord::Base
  belongs_to :club
  has_many :invitations
  has_many :responses
  has_many :message_histories
  has_many :messages, through: :message_histories
  has_many :taggings
  has_many :tags, through: :taggings, source: :tag
  has_many :assign_histories
  has_many :checklists, through: :assign_histories
  serialize :extra_info

  scope :generation_sorted_desc, -> { order(generation_id: :desc) }
  scope :responsed_to_notice, -> (notice) { joins(:responses).merge(Response.where(notice: notice)) }
  Response::STATUSES.each do |status|
    scope "responsed_#{status}", -> (notice) { responsed_to_notice(notice).merge(Response.where(status: status)) }
  end
  scope :responsed_not_to_notice, -> (notice, club) {
  SQL = %{LEFT OUTER JOIN (SELECT * FROM responses WHERE responses.notice_id = #{notice.id} and responses.club_id = #{club.id}) A
      ON users.id = A.user_id
      WHERE A.status is null
      }
  joins(SQL) }

  scope :order_by_gid, -> {order(generation_id: :desc)}
  scope :order_by_responsed_at, -> {order('responses.created_at ASC')}
  scope :order_by_read_at, -> {order('read_activity_marks.created_at DESC')}

  acts_as_reader

  validates_presence_of :username, :phone_number, :email, :club_id
  validates_uniqueness_of :phone_number, :email, scope: :club_id

  before_validation :normalize_phone_number
  before_validation :strip!

  attr_accessor :regard_as_activated, :remember_me

  def responsed_to?(notice)
    responses.exists?(notice: notice)
  end
  def response_status(notice)
    response = responses.find_by(notice: notice)
    if response
      response.status
    else
      "not"
    end

  end

  def activated?
    activated || regard_as_activated == true
  end

  def strip!
    strip_to = [:username, :email, :major, :student_id, :sex, :home_phone_number, :emergency_phone_number, :habitat_id, :member_type, :birth ]
    strip_to.each{|column| self[column].strip! if self[column]}
  end

# private
  def normalize_phone_number
    normalizer = FormNormalizers::PhoneNumberNormalizer.new
    self.phone_number = normalizer.normalize(phone_number) if !phone_number.blank?
  rescue FormNormalizers::NormalizeError => e
    errors.add(:phone_number, "가 잘못되었습니다.")
  end
end