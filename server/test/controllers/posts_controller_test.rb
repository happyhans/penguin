require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:random_user)
    @admin = create(:random_admin_user)

    @post = create(:post, user: @admin)
    @another_post = create(:post)

    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    user_jwt = (JSON.parse @response.body)['jwt']
    @user_header = { 'Authorization': "Bearer #{user_jwt}" }
    
    post sign_in_url, params: { email: @admin.email, password: '123456' }, as: :json
    admin_jwt = (JSON.parse @response.body)['jwt']
    @admin_header = { 'Authorization': "Bearer #{admin_jwt}" }
  end

  test 'should get index' do
    get posts_url, as: :json
    assert_response :ok
    assert response.body == PostSerializer.new(Post.all).serialized_json
  end

  test 'should create post' do
    assert_difference('Post.count', 1) do
      post posts_url, params: { post: { title: Faker::Lorem.sentence, body: Faker::Lorem.sentence }}, as: :json, headers: @admin_header      
    end

    assert_response :created
    assert response.body == PostSerializer.new(Post.last).serialized_json
  end

  test 'should not create post without auth' do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { title: Faker::Lorem.sentence, body: Faker::Lorem.sentence }}, as: :json      
    end

    assert_response :unauthorized
  end

  test 'should not create post as non-admin' do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { title: Faker::Lorem.sentence, body: Faker::Lorem.sentence }}, as: :json, headers: @user_header
    end

    assert_response :forbidden    
  end

  test 'should update post' do
    patch post_url(id: @post.id), params: { post: { title: 'Updated title!' }}, as: :json, headers: @admin_header
    assert_response :ok
    assert @post.reload.title == 'Updated title!'
    assert response.body == PostSerializer.new(@post.reload).serialized_json
  end

  test 'should update another post as non-author' do
    patch post_url(id: @another_post.id), params: { post: { title: 'Updated title!' }}, as: :json, headers: @admin_header
    assert_response :ok
    assert @another_post.reload.title == 'Updated title!'
    assert response.body == PostSerializer.new(@another_post.reload).serialized_json
  end

  test 'should not update post without auth' do
    original_title = @post.title
    patch post_url(id: @post.id), params: { post: { title: 'Updated title!' }}, as: :json
    assert_response :unauthorized
    assert @post.reload.title == original_title    
  end

  test 'should not update post as non-admin' do
    original_title = @post.title
    patch post_url(id: @post.id), params: { post: { title: 'Updated title!' }}, as: :json, headers: @user_header
    assert_response :forbidden
    assert @post.reload.title == original_title    
  end

  test 'should destroy post' do
    assert_difference('Post.count', -1) do
      delete post_url(id: @post.id), headers: @admin_header
    end

    assert_response :no_content
  end

  test 'should destroy post as non-author' do
    assert_difference('Post.count', -1) do
      delete post_url(id: @another_post.id), headers: @admin_header
    end

    assert_response :no_content    
  end

  test 'should not destroy post without auth' do
    assert_no_difference('Post.count') do
      delete post_url(id: @post.id)
    end

    assert_response :unauthorized    
  end

  test 'should not destroy post as non-admin' do
    assert_no_difference('Post.count') do
      delete post_url(id: @post.id), headers: @user_header
    end

    assert_response :forbidden
  end
end
