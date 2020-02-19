require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:random_user)
    @another_user = create(:random_user)
    @random_user = create(:random_user)
    @friendship = create(:friendship, user: @user, friend: @another_user)

    @conversation = create(:conversation, users: [@user, @another_user])
    @conversation.messages << build(:message, user: @user)
    @conversation.messages << build(:message, user: @another_user)
    @conversation.messages << build(:message, user: @user)
    @conversation.messages << build(:message, user: @another_user)

    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    user_jwt = (JSON.parse @response.body)['jwt']
    @user_header = { 'Authorization': "Bearer #{user_jwt}" }
    
    post sign_in_url, params: { email: @random_user.email, password: '123456' }, as: :json
    random_user_jwt = (JSON.parse @response.body)['jwt']
    @random_user_header = { 'Authorization': "Bearer #{random_user_jwt}" }
  end

  test 'should get index' do
    get conversation_messages_url(conversation_id: @conversation.id), headers: @user_header
    assert_response :ok
    assert response.body == MessageSerializer.new(@conversation.messages).serialized_json
  end

  test 'should not get index without auth' do
    get conversation_messages_url(conversation_id: @conversation.id)
    assert_response :unauthorized    
  end

  test 'should not get messages as non-participant in conversation' do
    get conversation_messages_url(conversation_id: @conversation.id), headers: @random_user_header
    assert_response :not_found
    assert response.body.empty?
  end

  test 'should create message' do
    assert_difference('Message.count', 1) do
      post conversation_messages_url(conversation_id: @conversation.id), params: { message: { body: 'Test message' }}, as: :json, headers: @user_header
    end

    assert_response :created
  end

  test 'should not create message without auth' do
    assert_no_difference('Message.count') do
      post conversation_messages_url(conversation_id: @conversation.id), params: { message: { body: 'Test message' }}, as: :json      
    end

    assert_response :unauthorized
  end

  test 'should not create message in conversation as non-participant' do
    assert_no_difference('Message.count') do
      post conversation_messages_url(conversation_id: @conversation.id), params: { message: { body: 'Test message' }}, as: :json, headers: @random_user_header
    end

    assert_response :not_found    
  end
end
