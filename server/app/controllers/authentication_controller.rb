class AuthenticationController < ApplicationController
  def sign_in
    email = params[:email]
    password = params[:password]

    user = User.find_by_email(email)
    if user.nil?
      return render json: { error: 'Unknown email / password combination.' }, status: :not_found    
    end

    user = user.authenticate(password)

    if user
      # Return JWT token and refresh token.
      payload = {
        exp: Time.now.to_i + 1.hour.to_i,
        iat: Time.now.to_i,
        user: {
          id: user.id
         }
      }

      jwt = JWT.encode payload, Rails.application.secret_key_base, 'HS256'
      refresh_token = RefreshToken.new(user: user)
      return head :internal_server_error unless refresh_token.save
      
      render json: { jwt: jwt, refresh_token: refresh_token.token }, status: :ok 
    else
      render json: { error: 'Unknown email / password combination.' }, status: :not_found
    end
  end

  def refresh_token
    token = params[:refresh_token]

    token_record = RefreshToken.find_by_token(token)
    return head :unauthorized if token_record.nil?

    if DateTime.now > token_record.expires
      return render json: { error: 'Expired refresh token.' }, status: :unauthorized
    else
      user = token_record.user

      payload = {
        exp: Time.now.to_i + 1.hour.to_i,
        iat: Time.now.to_i,
        user: {
          id: user.id
        }
      }

      jwt = JWT.encode payload, Rails.application.secret_key_base, 'HS256'
      refresh_token = RefreshToken.new(user: user)
      return head :internal_server_error unless refresh_token.save
           
      render json: { jwt: jwt, refresh_token: refresh_token.token }, status: :ok
    end    
  end
end
