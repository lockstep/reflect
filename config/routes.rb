Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :companies, only: [ :create, :show] do
    resources :questions, shallow: true, only: [ :create ]
  end
  resources :employments, only: [ :create ]
  root to: "static#home"
end
