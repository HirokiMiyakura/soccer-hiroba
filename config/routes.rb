Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  resources :users
  resources :sessions, only: [ :new, :create, :destroy ]
  root 'static_pages#home'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'new'
  match '/signout', to: 'sessions#destroy', via: 'delete'
end
