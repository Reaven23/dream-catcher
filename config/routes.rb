Rails.application.routes.draw do
  get "webmanifest"    => "pwa#manifest"
  get "service-worker" => "pwa#service_worker"

  devise_for :users

  root 'home#index'

  resources :dreams, only: [:index, :show, :new, :create, :destroy]
  post 'transcribe', to: 'transcriptions#create'
  get 'quiz/new', to: 'quiz#new', as: 'new_quiz'
  post 'quiz', to: 'quiz#create', as: 'quiz'
  resources :global_analyses, only: [:index, :show, :create, :destroy]

  # Dashboard utilisateur
  resource :dashboard, only: [:show], controller: 'dashboard' do
    patch :update_profile
    patch :update_quiz
    delete :destroy_account
  end

  resources :plants, only: [:create, :destroy]

  # Page spéciale "Pour toi"
  get 'pour-toi', to: 'special#show', as: 'special_page'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
