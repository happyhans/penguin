require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @another_user = users(:two)

    @pompom = users(:pompom)
    @poppop = users(:poppop)    
    @existing_friendship = friendships(:pompom_poppop_friendship)
  end

  test "both user and friend should exist in the friendship" do
    friendship = Friendship.new(user: @user)
    assert_not friendship.save
    assert friendship.errors.full_messages == ['Friend must exist']
    friendship = Friendship.new(friend: @another_user)
    assert_not friendship.save
    assert friendship.errors.full_messages == ['User must exist']
  end

  test "duplicate friendship should not exist" do
    friendship = Friendship.create(user: @pompom, friend: @poppop)
    assert_not friendship.save
    assert friendship.errors.full_messages == ['Friend already exists in friends list']
  end
 
  test "inverse friendship/relationship should be created on success" do
    friendship = Friendship.create(user: @user, friend: @another_user)
    assert Friendship.find_by(user: @another_user, friend: @user)
  end

  test "inverse friendship/relationship should be destroyed on success" do
    @existing_friendship.destroy
    assert Friendship.find_by(user: @poppop, friend: @pompom).nil?
  end
end
