require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    @user_jwt = (JSON.parse @response.body)['jwt']

    @another_user = users(:two)
    post sign_in_url, params: { email: @another_user.email, password: '123456' }, as: :json
    @another_user_jwt = (JSON.parse @response.body)['jwt']
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post sign_up_url, params: { user: { email: 'unique@email.com', password: '123456' } }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: 'modified@email.com' }}, as: :json, headers: { 'Authorization': "Bearer #{@user_jwt}" }
    assert_response 200
    assert @user.reload.email == 'modified@email.com'
  end

  test "should not update user without auth" do
    patch user_url(@user), params: { user: { email: 'poppop@penguin.com', password: '1234567' } }, as: :json
    assert_response :unauthorized
    assert @user.reload.email != 'poppop@penguin.com' 
  end

  test "should not be able to update another user" do
    patch user_url(@user), params: { user: { email: 'modified@email.com' }}, as: :json, headers: { 'Authorization': "Bearer #{@another_user_jwt}" }
    assert_response :forbidden
    assert @user.reload.email != 'modified@email.com'
  end
  
  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json, headers: { 'Authorization': "Bearer #{@user_jwt}" }
    end

    assert_response 204
  end

  test "should not destroy user without auth" do
    assert_no_difference('User.count') do
      delete user_url(@user), as: :json
    end

    assert_response :unauthorized
  end

  test "should not be able to destroy another user" do
    assert_no_difference('User.count') do
      delete user_url(@user), as: :json, headers: { 'Authorization': "Bearer #{@another_user_jwt}" }
    end

    assert_response :forbidden
  end

  test "POST /forgot_password : should return 404 if user not found" do
    post forgot_password_url, params: { email: 'dne@dne.dne' }, as: :json
    assert_response :not_found
  end
  
  test "POST /forgot_password : should return :ok (200) and generate reset_password_token if user found" do
    post forgot_password_url, params: { email: @user.email }, as: :json
    assert_response :ok
    assert @user.reload.reset_password_token != nil
    assert @user.reload.reset_password_token_expires != nil
  end

  test "POST /reset_password/:token should return :not_found (404) if reset_password_token does not exist" do
    post reset_password_url(token: 'dnednedne'), params: { password: '12345678' }, as: :json
    assert_response :not_found
  end

  test 'POST /reset_password/:token should return :unprocessable_entity (422) if token has expired' do
    post reset_password_url(token: @another_user.reset_password_token), params: { password: '12345678' }, as: :json
    assert_response :unprocessable_entity
    assert @response.body == '{"reset_password_token":["has expired."]}'
  end

  test 'POST /reset_password/:token should return :ok (200) if reset_password is successful' do
    @user.reset_password_token = 'abcdefg'
    @user.reset_password_token_expires = DateTime.now + 24.hours
    @user.save
    
    post reset_password_url(token: @user.reload.reset_password_token), params: { password: '12345678' }, as: :json
    assert_response :ok
    assert @user.reload.authenticate('12345678')
  end
end
