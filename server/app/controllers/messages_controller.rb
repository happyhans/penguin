class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_conversation
  before_action :verify_participant
  
  def index
    @messages = MessageSerializer.new(@conversation.messages).serialized_json
    render json: @messages
  end

  def create
    @message = Message.new(message_params)
    @message.user = @current_user
    @message.conversation = @conversation
    
    if @message.save
      head :created
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end    
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
  
  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def verify_participant
    if !@conversation.users.include?(@current_user)
      return head :not_found
    end
  end
end
