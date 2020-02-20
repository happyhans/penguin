require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:random_user)
    @another_user = create(:random_user)
    @admin = create(:random_admin_user)

    @post = create(:post, user: @admin)
    @comment = create(:comment, commentable: @post, user: @user)
    
    post sign_in_url, params: { email: @user.email, password: '123456' }, as: :json
    user_jwt = (JSON.parse @response.body)['jwt']
    @user_header = { 'Authorization': "Bearer #{user_jwt}" }

    post sign_in_url, params: { email: @another_user.email, password: '123456' }, as: :json
    another_user_jwt = (JSON.parse @response.body)['jwt']
    @another_user_header = { 'Authorization': "Bearer #{another_user_jwt}" }
    
    post sign_in_url, params: { email: @admin.email, password: '123456' }, as: :json
    admin_jwt = (JSON.parse @response.body)['jwt']
    @admin_header = { 'Authorization': "Bearer #{admin_jwt}" }
  end

  test 'should get index' do
    get post_comments_url(post_id: @post.id), as: :json
    assert_response :ok
    assert response.body == CommentSerializer.new(@post.comments).serialized_json
  end

  test 'should show comment' do
    get post_comment_url(post_id: @post.id, id: @comment.id), as: :json
    assert_response :ok
    assert response.body == CommentSerializer.new(@comment).serialized_json
  end

  test 'should create comment' do
    assert_difference('Comment.count', 1) do
      post post_comments_url(post_id: @post.id), params: { comment: { body: Faker::Lorem.sentence }}, as: :json, headers: @user_header
    end

    assert_response :created
    assert response.body == CommentSerializer.new(Comment.last).serialized_json
  end

  test 'should not create comment without auth' do
    assert_no_difference('Comment.count') do
      post post_comments_url(post_id: @post.id), params: { comment: { body: Faker::Lorem.sentence }}, as: :json
    end

    assert_response :unauthorized
  end

  test 'should update comment as author' do
    patch post_comment_url(post_id: @post.id, id: @comment.id), params: { comment: { body: 'Updated comment!' }}, as: :json, headers: @user_header
    assert_response :ok
    assert @comment.reload.body == 'Updated comment!'
    assert response.body == CommentSerializer.new(@comment.reload).serialized_json
  end

  test 'should update comment as admin' do
    patch post_comment_url(post_id: @post.id, id: @comment.id), params: { comment: { body: 'Updated comment!' }}, as: :json, headers: @admin_header
    assert_response :ok
    assert @comment.reload.body == 'Updated comment!'    
    assert response.body == CommentSerializer.new(@comment.reload).serialized_json
  end

  test 'should not update comment without auth' do
    original_body = @comment.body
    patch post_comment_url(post_id: @post.id, id: @comment.id), params: { comment: { body: 'Updated comment!' }}, as: :json
    assert_response :unauthorized
    assert @comment.reload.body == original_body
  end

  test 'should not not update comment as non-author/admin' do
    original_body = @comment.body
    patch post_comment_url(post_id: @post.id, id: @comment.id), params: { comment: { body: 'Updated comment!' }}, as: :json, headers: @another_user_header
    assert_response :forbidden
    assert @comment.reload.body == original_body    
  end

  test 'should destroy comment as author' do
    assert_difference('Comment.count', -1) do
      delete post_comment_url(post_id: @post.id, id: @comment.id), headers: @user_header
    end

    assert_response :no_content
  end

  test 'should destroy comment as admin' do
    assert_difference('Comment.count', -1) do
      delete post_comment_url(post_id: @post.id, id: @comment.id), headers: @admin_header
    end

    assert_response :no_content    
  end

  test 'should not destroy comment without auth' do
    assert_no_difference('Comment.count') do
      delete post_comment_url(post_id: @post.id, id: @comment.id)
    end

    assert_response :unauthorized    
  end

  test 'should not destroy comment as non-author/admin' do
    assert_no_difference('Comment.count') do
      delete post_comment_url(post_id: @post.id, id: @comment.id), headers: @another_user_header
    end

    assert_response :forbidden    
  end
end
