class FriendshipSerializer
  include FastJsonapi::ObjectSerializer
  attribute :created_at
  belongs_to :user, record_type: :user
  belongs_to :friend, record_type: :user
end
