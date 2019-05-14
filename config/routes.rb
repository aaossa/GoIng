Rails.application.routes.draw do
  # Authentication routes
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/signout', to: 'sessions#destroy', via: [:get, :post]

  # Time blocks
  get 'modulos/opciones', to: 'time_blocks#options'
  resources :time_blocks, path: 'modulos'

  # Courses
  resources :courses, path: 'cursos' do
    get 'ayudantes', to: 'courses#teaching_assistants', on: :member
  end

  # Requests
  resources :requests, path: 'peticiones'

  # Confirmed classes
  # match 'clases/:id/:slug', to: 'clases#show', via: [:get]
  resources :confirmed_classes, path: 'clases', param: :'id_slug', only: [:show, :index, :destroy, :new] do
    member do
        get 'ayudantes/si', to: 'confirmed_classes#answer_teaching_assistant_yes'
        get 'ayudantes/no', to: 'confirmed_classes#answer_teaching_assistant_no'
        get 'alumnos/si', to: 'confirmed_classes#answer_student_yes'
        get 'alumnos/no', to: 'confirmed_classes#answer_student_no'
    end
  end

  # Teaching assistants
  resources :teaching_assistants, path: 'ayudantes'

  # Root
  root 'welcome#index'
end
