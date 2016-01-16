Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "users/registrations", omniauth_callbacks: "omniauth_callbacks" }

  concern :votable do
    member do
      patch :vote
    end
  end

  root 'questions#index'
  devise_scope :user do
    get "login", to: "users/sessions#new"
    delete "logout", to: "users/sessions#destroy"
    get "signup", to: "users/registrations#new"
  end

  post "handle_email", to: "omniauth_email#handle_email"
  get "confirm_email", to: "omniauth_email#confirm_email"

  resources :questions, concerns: [:votable] do
    resources :comments, only: [:create]
    resources :answers, only: [:show, :create, :update, :destroy], concerns: [:votable] do
      patch :switch_promotion, on: :member
    end
  end

  resources :answers, only: [] do
    resources :comments, only: [:create]
  end

  resources :attachments, only: [:destroy]
end
