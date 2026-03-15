Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: %i[show new create edit update]

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
