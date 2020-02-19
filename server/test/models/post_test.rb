require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @random_admin = create(:random_admin_user)
    @random_user = create(:random_user)
  end

  test 'title should not be null' do
    post = Post.new(title: '', body: Faker::Lorem.sentence, user: @random_admin)
    assert_not post.save
    assert post.errors.full_messages == ["Title can't be blank"]
  end

  test 'body should not be blank' do
    post = Post.new(title: Faker::Lorem.sentence, body: '', user: @random_admin)
    assert_not post.save
    assert post.errors.full_messages == ["Body can't be blank"]
  end

  test 'author should not be nil' do
    post = Post.new(title: Faker::Lorem.sentence, body: Faker::Lorem.sentence)
    assert_not post.save
    assert post.errors.full_messages.include? "User can't be blank"
  end

  test 'author should be an admin' do
    post = Post.new(title: Faker::Lorem.sentence, body: Faker::Lorem.sentence, user: @random_user)
    assert_not post.save
    assert post.errors.full_messages == ["User is not an admin"]
  end
end
