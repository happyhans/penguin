class PostSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  has_many :comments, as: :commentable

  attributes :title, :body, :created_at, :updated_at
end
