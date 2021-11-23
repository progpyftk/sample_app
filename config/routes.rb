Rails.application.routes.draw do
  get '/signup', to: 'users#new' # se nao tivessemos esse, seria users/new, mas dessa forma pode ser apenas /signup
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  resources :users
end
