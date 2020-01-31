class AddResetPasswordTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_password_token, :string, null: true, default: nil
    add_column :users, :reset_password_token_expires, :datetime, null: true, default: nil
  end
end
