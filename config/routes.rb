Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  root 'questions#index'
  devise_scope :user do
    get "login", to: "users/sessions#new"
    get "logout", to: "users/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end

  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:index, :show, :new, :create]
  end
end
