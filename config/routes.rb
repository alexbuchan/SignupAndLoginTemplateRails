Rails.application.routes.draw do
  root 'application#home'
  resources :users
  post '/auth/login', to: 'authentication#login'
  get '/auth/contacts', to: 'authentication#contacts'
  get '/*path', to: 'application#not_found'
end
