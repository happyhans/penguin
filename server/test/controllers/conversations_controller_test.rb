require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_a = create(:random_user)
    @user_b = create(:random_user)
    @user_c = create(:random_user)

    @friendship_a = create(:friendship, user: @user_a, friend: @user_b)
    @friendship_b = create(:friendship, user: @user_a, friend: @user_c)

    @conversation_a = create(:conversation, users: [@user_a, @user_b])
    @conversation_b = create(:conversation, users: [@user_a, @user_c])

    post sign_in_url, params: { email: @user_a.email, password: '123456' }, as: :json
    user_a_jwt = (JSON.parse @response.body)['jwt']
    @user_a_header = { 'Authorization': "Bearer #{user_a_jwt}" }

    post sign_in_url, params: { email: @user_b.email, password: '123456' }, as: :json
    user_b_jwt = (JSON.parse @response.body)['jwt']
    @user_b_header = { 'Authorization': "Bearer #{user_b_jwt}" }

    post sign_in_url, params: { email: @user_c.email, password: '123456' }, as: :json
    user_c_jwt = (JSON.parse @response.body)['jwt']
    @user_c_header = { 'Authorization': "Bearer #{user_c_jwt}" }
  end

  test 'should get index' do
    get conversations_url, as: :json, headers: @user_a_header
    assert_response :ok
    assert response.body == ConversationSerializer.new(@user_a.conversations).serialized_json
  end

  test 'should not get index without auth' do
    get conversations_url, as: :json
    assert_response :unauthorized    
  end

  test 'should get conversation' do
    get conversation_url(@conversation_a), as: :json, headers: @user_a_header
    assert_response :ok
    assert response.body == ConversationSerializer.new(@conversation_a).serialized_json
  end

  test 'should not get conversation without auth' do
    get conversation_url(@conversation_a), as: :json
    assert_response :unauthorized
  end

  test 'should not get conversation as a non-participant' do
    get conversation_url(@conversation_b), as: :json, headers: @user_b_header
    assert_response :not_found
  end

  test 'should create conversation' do
    assert_difference('Conversation.count', 1) do
      post conversations_url, params: { conversation: { users: [@user_b.id] }}, as: :json, headers: @user_a_header
    end

    assert_response :created
  end

  test 'should not create conversation without auth' do
    assert_no_difference('Conversation.count') do
      post conversations_url, params: { conversation: { users: [@user_b.id] }}, as: :json
    end

    assert_response :unauthorized    
  end

  test 'should not create conversation with non-friend' do
    assert_no_difference('Conversation.count') do
      post conversations_url, params: { conversation: { users: [@user_a.id, @user_c.id] }}, as: :json, headers: @user_b_header
    end

    assert_response :unprocessable_entity
  end

  test 'should update conversation, remove self' do
    patch conversation_url(@conversation_a), params: { conversation: { users: [@user_b.id] }}, as: :json, headers: @user_a_header
    assert_response :ok
    assert response.body == ConversationSerializer.new(@conversation_a.reload).serialized_json
  end

  test 'should update conversation, remove another participant' do
    patch conversation_url(@conversation_a), params: { conversation: { users: [@user_a.id] }}, as: :json, headers: @user_a_header
    assert_response :ok
    assert response.body == ConversationSerializer.new(@conversation_a.reload).serialized_json
  end

  test 'should update conversation, add participant' do
    patch conversation_url(@conversation_a), params: { conversation: { users: [@user_a.id, @user_b.id, @user_c.id] }}, as: :json, headers: @user_a_header
    assert_response :ok
    assert response.body == ConversationSerializer.new(@conversation_a.reload).serialized_json
  end

  test 'should not update conversation with non-friend participant' do
    patch conversation_url(@conversation_a), params: { conversation: { users: [@user_a.id, @user_b.id, @user_c.id] }}, as: :json, headers: @user_b_header
    assert_response :unprocessable_entity
    assert response.body == { error: 'You cannot update/create a conversation with a user you are not friends with.' }.to_json
  end

  test 'should not update conversation as non-participant' do
    patch conversation_url(@conversation_a), params: { conversation: { users: [@user_a.id, @user_b.id, @user_c.id] }}, as: :json, headers: @user_c_header
    assert_response :not_found
  end
  
  test 'should destroy conversation' do
    assert_difference('Conversation.count', -1) do
      delete conversation_url(@conversation_b), headers: @user_a_header
    end

    assert_response :no_content
  end

  test 'should not destroy conversation as non-participant' do
    assert_no_difference('Conversation.count') do
      delete conversation_url(@conversation_b), headers: @user_b_header
    end

    assert_response :not_found
  end
end
