class FriendRequestSerializer
  include FastJsonapi::ObjectSerializer
  attribute :created_at
  belongs_to :receiver, record_type: :user
  belongs_to :sender, record_type: :user
end
