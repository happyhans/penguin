class FriendsController < ApplicationController
  before_action :require_login
  before_action :set_friendship, only: [:destroy]
  
  def index
    @friendships = @current_user.friendships
    json = FriendshipSerializer.new(@friendships).serialized_json
    render json: json
  end

  def destroy
    @friendship.destroy
  end

  private

  def set_friendship
    @friendship = @current_user.friendships.find_by(friend_id: params[:id])
  end
end
