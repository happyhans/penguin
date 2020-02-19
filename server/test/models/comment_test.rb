require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = create(:random_user)
    @post = create(:post)
    @comment = create(:comment, user: @user, commentable: @post)
  end

  test 'body should exist' do
    comment = Comment.new(user: @user, commentable: @post)
    assert_not comment.save
  end

  test 'user should exist on creation' do
    comment = Comment.new(body: Faker::Lorem.sentence, commentable: @post)
    assert_not comment.save
  end

  test 'commentable should exist' do
    comment = Comment.new(body: Faker::Lorem.sentence, user: @user)
    assert_not comment.save
  end

  test 'commentable can be a post' do
    comment = Comment.new(body: Faker::Lorem.sentence, user: @user, commentable: @post)
    assert comment.save
  end

  test 'commentable can be another comment' do
    comment = Comment.new(body: Faker::Lorem.sentence, user: @user, commentable: @comment)
    assert comment.save
  end
  
  test 'body should be at least 6 characters long' do
    comment = Comment.new(body: 'abc', user: @user, commentable: @post)
    assert_not comment.save
  end

  test 'body should be less than or equal to 300 characters long' do
    comment = Comment.new(body: 'a' * 1000, user: @user, commentable: @post)
    assert_not comment.save
  end

  test 'should be able to remove user after creation' do
    @comment.user = nil
    assert @comment.reload.save
  end
end
