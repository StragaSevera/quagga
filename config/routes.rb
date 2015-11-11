Rails.application.routes.draw do
  root 'questions#index'

  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:index, :show, :new, :create]
  end
end
