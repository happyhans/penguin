class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :user, presence: true
  
  validate :user_must_be_an_admin

  has_many :comments, as: :commentable, dependent: :destroy
  
  private

  def user_must_be_an_admin
    if !self.user || self.user.admin != true
      errors.add(:user, "is not an admin")
    end
  end
end
