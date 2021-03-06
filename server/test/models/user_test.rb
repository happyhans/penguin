require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  VALID_PASSWORD = '123456'
  
  setup do
    @user = create(:user)
    @another_user = create(:user, email: 'hans@corgi.com')
  end

  test "should not save a user without an email" do
    inv_user = User.new(password: UserTest::VALID_PASSWORD)
    assert inv_user.save == false
  end

  test "should not save a user without a valid email" do
    inv_user = User.new(email: 'notanemail', password: UserTest::VALID_PASSWORD)
    assert inv_user.save == false
  end
  
  test "should not save a user without a password" do
    inv_user = User.new(email: 'unique@unique.com')
    assert inv_user.save == false
  end

  test "should not allow users with duplicate emails" do
        duplicate_user = User.new(
          email: @user.email,
          password: UserTest::VALID_PASSWORD)
        assert duplicate_user.save == false
  end

  test "should not save a user with a password less than 6 chars" do
    inv_user = User.new(email: 'unique@unique.com', password: '123')
    assert inv_user.save == false
  end
  
  test "should save a valid user" do
    valid_user = User.new(email: 'unique@unique.com',
                          password: UserTest::VALID_PASSWORD)
    assert valid_user.save
  end
  
  test "#generate_reset_password_token" do
    @user.generate_reset_password_token
    assert @user.reset_password_token != nil
    assert @user.reset_password_token_expires != nil
  end

  test "#generate_reset_password_token reset_password_token should be unique" do
    @user.generate_reset_password_token
    @another_user.generate_reset_password_token

    assert @user.reset_password_token != @another_user.reset_password_token
  end

  test "#generate_reset_password_token reset_password_token expiration should be 24 hours ahead" do
    @user.generate_reset_password_token

    assert DateTime.now.utc.tomorrow.day == @user.reset_password_token_expires.day
  end

  test "should generate a uuid for each new user" do
    user = User.create(email: 'new@new.com', password: '123456')
    assert user.uuid != nil
    user2 = User.create(email: 'new2@new2.com', password: '123456')
    assert user2.uuid != nil
    assert user.uuid != user2.uuid
  end

  test "user should not have admin priveleges by default" do
    user = create(:random_user)
    assert_not user.reload.admin
  end
end
