require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  setup do
    @existing_friend_request = create(:friend_request)

    @user = create(:random_user)
    @another_user = create(:random_user)
  end

  test "should prevent duplicate friend request from being created" do
    friend_request = FriendRequest.new(sender: @existing_friend_request.sender,
                                       receiver: @existing_friend_request.receiver)
    assert_not friend_request.save
  end

  test "#accept" do
    initial_friendship_count = Friendship.count
    initial_friend_request_count = FriendRequest.count

    @existing_friend_request.accept
    assert Friendship.count == (initial_friendship_count + 2)
    assert FriendRequest.count == (initial_friend_request_count - 1)
  end

  test "#reject" do
    initial_friendship_count = Friendship.count
    initial_friend_request_count = FriendRequest.count

    @existing_friend_request.reject
    assert Friendship.count == initial_friendship_count
    assert FriendRequest.count == (initial_friend_request_count - 1)    
  end

  test "saves valid, unique friend request" do
    assert_difference('FriendRequest.count', 1) do
      FriendRequest.create(sender: @user, receiver: @another_user)
    end
  end
end
