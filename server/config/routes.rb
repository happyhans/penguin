Rails.application.routes.draw do
  post '/sign_in', to: 'authentication#sign_in', as: 'sign_in'
  post '/refresh_token', to: 'authentication#refresh_token', as: 'refresh_token'
  post '/sign_up', to: 'users#create', as: 'sign_up'
  post '/forgot_password', to: 'users#forgot_password', as: 'forgot_password'
  post '/reset_password/:token', to: 'users#reset_password', as: 'reset_password'
  
  resources :users, except: :create
  resources :friend_requests, except: [:show]
  
  resources :friends, only: [:index, :destroy]
  resources :conversations
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
