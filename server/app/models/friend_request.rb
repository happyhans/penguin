class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :receiver, uniqueness: { scope: :sender, message: 'already has a pending friend request' }

  def accept
    friendship = nil
    ActiveRecord::Base.transaction do
      friendship = Friendship.create!(user: sender, friend: receiver)
      self.destroy!
    end

    friendship
  end

  def reject
    ActiveRecord::Base.transaction do
      self.destroy!
    end    
  end
end

