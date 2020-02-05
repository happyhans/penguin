class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  
  has_many :refresh_tokens, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships

  before_save :generate_uuid
  
  def generate_reset_password_token
    new_token = SecureRandom.base58(16)
    until User.find_by_reset_password_token(new_token).nil?
      new_token = SecureRandom.base58(16)
    end

    self.reset_password_token = new_token
    self.reset_password_token_expires = DateTime.now + 24.hours
  end

  private

  def generate_uuid
    uuid = SecureRandom.uuid
    until User.find_by_uuid(uuid).nil?
      uuid = SecureRandom.uuid
    end

    self.uuid = uuid
  end
end
