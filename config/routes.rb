Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Temporary, delete 3 as below
  root to: 'pages#home'
  get "home", to: "pages#home"
  post "/output_to_map", to: "pages#output_to_map"
  
end
