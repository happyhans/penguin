class FriendRequestsController < ApplicationController
  before_action :require_login
  before_action :set_friend_request, only: [:update, :destroy]
  before_action :verify_receiver, only: [:update, :destroy]
  
  def index
    incoming_friend_requests = FriendRequestSerializer.new(@current_user.incoming_friend_requests).serializable_hash
    outgoing_friend_requests = FriendRequestSerializer.new(@current_user.outgoing_friend_requests).serializable_hash

    @friend_requests = { 'incoming': incoming_friend_requests, 'outgoing': outgoing_friend_requests }    
    render json: @friend_requests
  end

  def create
    @friend_request = @current_user.outgoing_friend_requests.new(receiver_id: params[:receiver_id])

    if @friend_request.save
      json = FriendRequestSerializer.new(@friend_request).serialized_json
      render json: json, status: :created
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  def update
    @friendship = @friend_request.accept
    json = FriendshipSerializer.new(@friendship).serialized_json
    render json: json, status: :created
  end

  def destroy
    @friend_request.reject
    head :no_content
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
    if @friend_request.nil?
      return head :not_found
    end
  end

  def verify_receiver
    if @friend_request.receiver != @current_user
      return head :not_found
    end
  end
end
