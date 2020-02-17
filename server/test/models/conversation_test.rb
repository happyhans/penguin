require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  setup do
    @user_a = create(:random_user)
    @user_b = create(:random_user)
    @user_c = create(:random_user)

    @conversation = create(:conversation, users: [@user_a, @user_b])
    @messages = [build(:message, user: @user_a),
                build(:message, user: @user_b),
                build(:message, user: @user_a)]
    @conversation.messages.push(@messages)
  end

  test 'conversation should destroy all messages if destroyed' do
    @conversation.destroy
    assert Message.where(conversation: @conversation).count == 0
  end
end
