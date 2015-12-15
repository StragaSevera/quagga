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

  resources :questions, only: [:index, :show, :new, :create, :update, :destroy], concerns: [:votable] do
    resources :answers, only: [:show, :create, :update, :destroy], concerns: [:votable] do
      member do
        patch :switch_promotion
      end
    end
  end

  resources :attachments, only: [:destroy]
end
