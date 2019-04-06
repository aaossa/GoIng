Rails.application.routes.draw do
  resources :confirmed_classes do
    post 'contact_teaching_assistant', to: 'confirmed_classes#contact_teaching_assistant', as: 'contact_teaching_assistant'
  end
  resources :time_blocks
  resources :teaching_assistants
  resources :courses do
    get 'teaching_assistants', :to => 'courses#teaching_assistants', on: :member
  end
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :requests

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/signout', to: 'sessions#destroy', via: [:get, :post]

  root 'welcome#index'
end
