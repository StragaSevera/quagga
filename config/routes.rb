Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:index, :show, :new, :create]
  end
end
