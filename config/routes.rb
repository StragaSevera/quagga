Rails.application.routes.draw do
  root 'questions#index'

  resources :questions, only: [:show, :new, :create]
end
