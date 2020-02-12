class UsersController < ApplicationController
  before_action :require_login, only: [:update, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :verify_user, only: [:update, :destroy]
  
  # GET /users
  def index
    @users = User.all
    json = UserSerializer.new(@users).serialized_json
    render json: json
  end

  # GET /users/1
  def show
    json = UserSerializer.new(@user).serialized_json
    render json: json
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      json = UserSerializer.new(@user).serialized_json
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # POST /forgot_password
  def forgot_password
    @user = User.find_by_email(params[:email])
    return head :not_found if @user.nil?

    @user.generate_reset_password_token
    if @user.save
      return head :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # POST /reset_password/<reset_password_token>
  def reset_password
    @user = User.find_by_reset_password_token(params[:token])
    return head :not_found if @user.nil?

    if @user.reset_password_token_expires < DateTime.now
      return render json: { reset_password_token: ['has expired.'] }, status: :unprocessable_entity
    end

    @user.password = params[:password]
    if @user.save
      return head :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end      
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def verify_user
      render status: :forbidden unless @current_user == @user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
