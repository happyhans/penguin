class ConversationSerializer
  include FastJsonapi::ObjectSerializer
  has_many :users
  has_many :messages
  
  attributes :created_at, :updated_at
end
