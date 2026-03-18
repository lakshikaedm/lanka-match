Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  resource :profile, only: %i[show new create edit update]
  resources :profiles, only: %i[index show], controller: "public_profiles", as: :public_profiles

  get "up" => "rails/health#show", as: :rails_health_check
end
