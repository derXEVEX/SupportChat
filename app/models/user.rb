class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, if: -> { new_record? || !password.nil? }

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
