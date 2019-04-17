Rails.application.routes.draw do
  resources :confirmed_classes do
    get 'teaching_assistant/yes', to: 'confirmed_classes#answer_teaching_assistant_yes'
    get 'teaching_assistant/no', to: 'confirmed_classes#answer_teaching_assistant_no'
    get 'student/yes', to: 'confirmed_classes#answer_student_yes'
    get 'student/no', to: 'confirmed_classes#answer_student_no'
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
