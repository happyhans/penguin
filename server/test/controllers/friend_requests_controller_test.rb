require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @existing_friend_request = friend_requests(:one)
    @user = users(:two)
    @another_user = users(:bella)

    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    user_jwt = (JSON.parse @response.body)['jwt']
    @user_header = { 'Authorization': "Bearer #{user_jwt}" }

    post sign_in_url, params: { email: @another_user.email, password: '123456' }, as: :json
    another_user_jwt = (JSON.parse @response.body)['jwt']
    @another_user_header = { 'Authorization': "Bearer #{another_user_jwt}" }
  end

  test "should get index" do
    get friend_requests_url, as: :json, headers: @user_header
    assert_response :success

    response_json = JSON.parse(response.body)
    
    assert response_json["incoming"] == JSON.parse(@user.incoming_friend_requests.to_json)
    assert response_json["outgoing"] == JSON.parse(@user.outgoing_friend_requests.to_json)
  end

  test "should not get index without auth" do
    get friend_requests_url, as: :json
    assert_response :unauthorized
  end

  test "should create friend request" do
    assert_difference('FriendRequest.count') do
      post friend_requests_url, as: :json, params: { receiver_id: @another_user.id }, headers: @user_header
    end
    assert_response :created
  end

  test "should not create friend request without auth" do
    assert_no_difference('FriendRequest.count') do
      post friend_requests_url, as: :json, params: { receiver_id: @another_user.id }
    end
    assert_response :unauthorized
  end
  
  test "should accept friend request" do
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    put friend_request_url(@existing_friend_request), as: :json, headers: @user_header

    assert FriendRequest.count == initial_friend_request_count - 1
    assert Friendship.count == initial_friendship_count + 2
    assert_response :created
  end

  test "should not accept friend request without auth" do 
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    put friend_request_url(@existing_friend_request), as: :json

    assert FriendRequest.count == initial_friend_request_count
    assert Friendship.count == initial_friendship_count
    assert_response :unauthorized    
  end

  test "should prevent a user from accepting another user's friend request" do
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    put friend_request_url(@existing_friend_request), as: :json, headers: @another_user_header

    assert FriendRequest.count == initial_friend_request_count
    assert Friendship.count == initial_friendship_count
    assert_response :not_found 
  end
  
  test "should reject friend request" do
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    delete friend_request_url(@existing_friend_request), as: :json, headers: @user_header

    assert FriendRequest.count == initial_friend_request_count - 1
    assert Friendship.count == initial_friendship_count
    assert_response :no_content
  end

  test "should not reject friend request without auth" do
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    delete friend_request_url(@existing_friend_request), as: :json

    assert FriendRequest.count == initial_friend_request_count
    assert Friendship.count == initial_friendship_count
    assert_response :unauthorized  
  end

  test "should prevent a user from rejecting another user's friend request" do
    initial_friend_request_count = FriendRequest.count
    initial_friendship_count = Friendship.count

    delete friend_request_url(@existing_friend_request), as: :json, headers: @another_user_header

    assert FriendRequest.count == initial_friend_request_count
    assert Friendship.count == initial_friendship_count
    assert_response :not_found
  end
end
