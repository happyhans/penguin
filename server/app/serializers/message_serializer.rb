class MessageSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  
  attributes :body, :created_at
end
