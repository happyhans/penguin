class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend, uniqueness: { scope: :user, message: 'already exists in friends list' }
  
  after_create_commit :create_inverse_relationship
  after_destroy_commit :destroy_inverse_relationship
  
  private

  def create_inverse_relationship
    inverse_relationship = Friendship.find_by(friend: self.user, user: self.friend)
    if inverse_relationship.nil?
      Friendship.create!(user: self.friend, friend: self.user)
    end
  end

  def destroy_inverse_relationship
    inverse_relationship = Friendship.find_by(friend: self.user, user: self.friend)

    if inverse_relationship
      inverse_relationship.destroy!
    end
  end
end
