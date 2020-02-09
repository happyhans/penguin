class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.integer :sender_id
      t.integer :receiver_id
      
      t.timestamps
    end

    add_foreign_key :friend_requests, :users, column: :sender_id
    add_foreign_key :friend_requests, :users, column: :receiver_id
    add_index :friend_requests, [:sender_id, :receiver_id], unique: true
  end
end
