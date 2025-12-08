Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  resources :dreams, only: [:index, :show, :new, :create]
  get 'quiz/new', to: 'quiz#new', as: 'new_quiz'
  post 'quiz', to: 'quiz#create', as: 'quiz'
  resource :global_analysis, only: [:show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
