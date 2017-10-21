Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'

  get '/home' => 'pages#home'

  get '/settings' => 'pages#settings'

  get '/faq' => 'pages#faq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Temporary, delete 2 as below
  root to: 'pages#home'
  get "home", to: "pages#home"
end
