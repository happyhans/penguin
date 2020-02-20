class CommentSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user
  belongs_to :commentable, record_type: :post

  attributes :body, :created_at, :updated_at
end
