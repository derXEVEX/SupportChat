class User < ApplicationRecord
  has_secure_password
  has_many :support_requests, dependent: :destroy


  ROLES = %w[user supporter admin].freeze

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :password, length: { minimum: 12 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { new_record? || !password.nil? }



  before_validation :set_default_role, on: :create

  def set_default_role
    self.role ||= "user"
  end

  def admin?
    role == "admin"
  end

  def supporter?
    role == "supporter"
  end


  def request_email_change(new_email)
    self.unconfirmed_email = new_email
    self.confirmation_token = SecureRandom.hex(20)
    save!
    Rails.logger.debug "Confirmation link: http://localhost:3000/confirm_email?token=#{confirmation_token}"
  end

  def confirm_email!
    return false unless unconfirmed_email.present? && confirmation_token.present?

    self.email = unconfirmed_email
    self.unconfirmed_email = nil
    self.confirmation_token = nil
    self.confirmed_at = Time.current
    save!
  end
end
