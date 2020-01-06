Rails.application.routes.draw do
  post '/sign_in', to: 'authentication#sign_in'
  post '/refresh_token', to: 'authentication#refresh_token'
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
