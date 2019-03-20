Rails.application.routes.draw do
  resources :time_blocks
  resources :teaching_assistants
  resources :courses
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :requests

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/signout', to: 'sessions#destroy', via: [:get, :post]

  root 'welcome#index'
end
