require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @existing_friendship = friendships(:pompom_poppop_friendship)
    @user = users(:pompom)

    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    user_jwt = (JSON.parse @response.body)['jwt']
    @user_header = { 'Authorization': "Bearer #{user_jwt}" }
  end

  test "should get index" do
    get friends_url, as: :json, headers: @user_header
    assert_response :success
    assert response.body == FriendshipSerializer.new(@user.friendships).serialized_json
  end

  test "should not get index without auth" do
    get friends_url, as: :json
    assert_response :unauthorized  
  end

  test "should remove friendship" do
    delete friend_url(@existing_friendship.friend.id), as: :json, headers: @user_header

    assert_response :no_content
    assert Friendship.count == 0
  end

  test "should not remove friendship without auth" do
    assert_no_difference('Friendship.count') do
      delete friend_url(@existing_friendship.friend.id), as: :json
    end
    
    assert_response :unauthorized    
  end
end
