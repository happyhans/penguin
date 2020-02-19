class Comment < ApplicationRecord
  # Optional because we want the comment and its subcomments to exist even
  # if this comment is deleted.
  belongs_to :user, optional: true

  belongs_to :commentable, polymorphic: true
  validates :body, presence: true, length: { minimum: 6, maximum: 300 }
  validate :validate_user_on_create, on: :create

  private

  def validate_user_on_create
    if self.user.nil?
      errors.add(:user, "must exist")
    end
  end
end
