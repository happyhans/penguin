class ApplicationController < ActionController::API
  def require_login
    if request.headers.include? 'Authorization'
      token = request.headers['Authorization'].split(' ').last      
      begin
        payload, header = JWT.decode token, Rails.application.secret_key_base, true, { algorithm: 'HS256' }
        user_id = payload['user']['id'].to_i
        @current_user = User.find(user_id)
      rescue JWT::DecodeError
        return render plain: 'A token must be passed.', status: :unauthorized 
      rescue JWT::ExpiredSignature
        return render plain: 'The token has expired.', status: :forbidden
      rescue JWT::InvalidIatError
        return render plain: 'The token does not have a valid "issued at" time', status: :forbidden
      end      
    else
      return render plain: 'A token must be passed.', status: :unauthorized
    end
  end
end
