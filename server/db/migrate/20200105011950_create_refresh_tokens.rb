class CreateRefreshTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :refresh_tokens do |t|
      t.string :token, null: false, unique: true
      t.datetime :expires, default: DateTime.now + 7.days
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
