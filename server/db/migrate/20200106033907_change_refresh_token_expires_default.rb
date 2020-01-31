class ChangeRefreshTokenExpiresDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:refresh_tokens, :expires, nil)
  end
end
