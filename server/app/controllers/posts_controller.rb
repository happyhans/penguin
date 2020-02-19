class PostsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_post, except: [:index, :create]
  
  def index
    json = PostSerializer.new(Post.all).serialized_json
    render json: json
  end

  def show
    json = PostSerializer.new(@post).serialized_json
    render json: json
  end

  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if @post.save
      json = PostSerializer.new(@post).serialized_json
      render json: json, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      json = PostSerializer.new(@post).serialized_json
      render json: json
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
end
