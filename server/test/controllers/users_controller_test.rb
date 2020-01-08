require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    @user_jwt = (JSON.parse @response.body)['jwt']
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'unique@email.com', password: '123456' } }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, password: '1234567' } }, as: :json, headers: { 'Authorization': "Bearer #{@user_jwt}" }
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json, headers: { 'Authorization': "Bearer #{@user_jwt}" }
    end

    assert_response 204
  end
end
