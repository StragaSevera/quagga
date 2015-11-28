Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "users/registrations" }

  root 'questions#index'
  devise_scope :user do
    get "login", to: "users/sessions#new"
    delete "logout", to: "users/sessions#destroy"
    get "signup", to: "users/registrations#new"
  end

  resources :questions, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :answers, only: [:show, :create, :update, :destroy]
  end
end
