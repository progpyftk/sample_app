Rails.application.routes.draw do

  # sessions routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # users routes
  resources :users
  get '/signup', to: 'users#new' # se nao tivessemos esse, seria users/new, mas dessa forma pode ser apenas /signup
  
  # static_pages routes
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
end
