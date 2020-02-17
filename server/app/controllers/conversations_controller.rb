class ConversationsController < ApplicationController
  before_action :require_login
  before_action :set_conversation, except: [:index, :create]
  before_action :verify_participant, except: [:index, :create]
  before_action :validate_users_param, only: [:create, :update]
  
  def index
    @conversations = ConversationSerializer.new(@current_user.conversations).serialized_json
    render json: @conversations
  end

  def show
    render json: ConversationSerializer.new(@conversation).serialized_json
  end

  def create
    @conversation = Conversation.new(**create_conversation_params)
    validate_users_param
    
    if @conversation.save
      json = ConversationSerializer.new(@conversation).serialized_json
      render json: json, status: :created, location: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @conversation.update(**update_conversation_params)
      json = ConversationSerializer.new(@conversation).serialized_json
      render json: json
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @conversation.destroy
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
    return head :not_found if @conversation.nil?
  end

  def verify_participant
    if !@conversation.users.include?(@current_user)
      return head :not_found
    end
  end

  def create_conversation_params
    params.require(:conversation).permit(:users)
  end
  
  def update_conversation_params 
    params.require(:conversation).permit(:users)
  end

  def validate_users_param
    if params[:conversation].has_key? :users
      params[:conversation][:users].each do |user_id|
        next if user_id == @current_user.id

        friend = @current_user.friendships.find_by(friend_id: user_id)
        if friend.nil?
          return render json: { error: 'You cannot update/create a conversation with a user you are not friends with.' }, status: :unprocessable_entity
        end
      end      
    end
  end

end
