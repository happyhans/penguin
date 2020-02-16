require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:random_user)
    @another_user = create(:random_user)
    @user_refresh_token = create(:refresh_token, user: @user)
    @another_user_refresh_token = create(:expired_refresh_token, user: @another_user)
  end

  test "should respond with a 404 if user not found" do
    post sign_in_url, params: { user: { email: 'dne@dne.com', password: '123456' }}, as: :json
    assert_response :not_found
  end

  test "should respond with a 404 if email/pw combination is invalid" do
    post sign_in_url, params: { email: @user.email, password: 'totally invalid' }, as: :json
    assert_response :not_found
  end

  test "should create a RefreshToken on successful sign_in" do
    assert_difference('RefreshToken.count') do
      post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    end

    assert_response :ok
  end
  
  test "should respond with a jwt and refresh token on successful sign_in" do
    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    assert_response :ok
    
    json_response = JSON.parse @response.body
    decoded_jwt = JWT::decode json_response['jwt'], nil, false
    payload, header = decoded_jwt[0], decoded_jwt[1]
    assert payload.dig('user', 'id').to_i == @user.id
  end

  test "should respond with :unauthorized (401) if refresh token does not exist when refreshing token" do
    post refresh_token_url, params: { refresh_token: 'dne' }, as: :json
    assert_response :unauthorized
  end

  test "should respond with :unauthorized (401) if provided refresh_token is expired" do
    post refresh_token_url, params: { refresh_token: @another_user_refresh_token.token }, as: :json
    
    assert_response :unauthorized
  end

  test "should get new jwt and refresh_token on valid refresh_token" do
    assert_difference('RefreshToken.count') do
      post refresh_token_url, params: { refresh_token: @user_refresh_token.token }, as: :json
    end
    
    assert_response :ok
    json_response = JSON.parse @response.body
    assert json_response.include? 'jwt'
    assert json_response.include? 'refresh_token'
  end
end
