Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  resources :users do
  	member do
  	  get :following, :followers
  	end
  end
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :articles do
    member { post :vote }
  end
  resources :comments
  resources :relationships, only: [ :create, :destroy ]
  root 'static_pages#home'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
end
