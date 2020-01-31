class RefreshToken < ApplicationRecord
  belongs_to :user
  has_secure_token :token

  before_create do
    self.expires = DateTime.now + 7.days
  end
end
