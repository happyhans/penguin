class RefreshToken < ApplicationRecord
  belongs_to :user
  has_secure_token :token
end
