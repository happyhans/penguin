class FriendsController < ApplicationController
  before_action :require_login
  before_action :set_friendship, only: [:destroy]
  
  def index
    @friends = @current_user.friends
    render json: @friends
  end

  def destroy
    @friendship.destroy
  end

  private

  def set_friendship
    @friendship = @current_user.friendships.find_by(friend_id: params[:id])
  end
end
