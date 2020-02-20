class CommentsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_post
  before_action :set_comment, except: [:index, :create]
  before_action :validate_author_or_admin, only: [:update, :destroy]
  
  def index
    json = CommentSerializer.new(@post.comments).serialized_json
    render json: json
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = @post
    @comment.user = @current_user

    if @comment.save
      json = CommentSerializer.new(@comment).serialized_json
      render json: json, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end    
  end

  def show
    json = CommentSerializer.new(@comment).serialized_json
    render json: json
  end

  def update
    if @comment.update(comment_params)
      json = CommentSerializer.new(@comment).serialized_json
      render json: json
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end
  
  private

  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def validate_author_or_admin
    if !(@current_user.admin? || @comment.user == @current_user)
      head :forbidden
    end
  end
end
