require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do    
    @user = create(:random_user)
    @another_user = create(:random_user)
    @conversation = create(:conversation, users: [@user, @another_user])
  end

  test 'message should not be blank' do
    message = build(:blank_message, conversation: @conversation, user: @user)
    assert_not message.save
  end
end
