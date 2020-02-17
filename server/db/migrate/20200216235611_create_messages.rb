class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :conversation_id
      t.integer :user_id
      t.string :body
      
      t.timestamps
    end
  end
end
