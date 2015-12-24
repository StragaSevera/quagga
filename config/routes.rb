Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "users/registrations" }

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
