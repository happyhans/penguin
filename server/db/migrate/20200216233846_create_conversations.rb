class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.timestamps
    end

    create_join_table :users, :conversations do |t|
      t.timestamps
    end
  end
end
