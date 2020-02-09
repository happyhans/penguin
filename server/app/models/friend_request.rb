class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :receiver, uniqueness: { scope: :sender, message: 'already has a pending friend request' }

  def accept
    ActiveRecord::Base.transaction do
      Friendship.create!(user: sender, friend: receiver)
      self.destroy!
    end
  end

  def reject
    ActiveRecord::Base.transaction do
      self.destroy!
    end    
  end
end

