Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  resources :users
  root 'static_pages#home'
  match '/signup', to: 'users#new', via: 'get'
end
