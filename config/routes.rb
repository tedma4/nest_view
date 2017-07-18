Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"
  get 'auth/:provider/callback', to: 'sessions#auth'
  get 'auth/failure', to: redirect('/')
  resources :sessions, only: [:create, :destroy, :new]
  resources :admin, only: [:create, :destroy]
  resources :users, only: [:create, :destroy]
end
