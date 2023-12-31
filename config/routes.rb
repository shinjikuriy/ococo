Rails.application.routes.draw do
  get 'static_pages/home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'users/:id', to: 'users#show', as: 'show_user'

  get 'users/:user_id/edit', to: 'profiles#edit', as: 'edit_profile'
  put 'users/:user_id/edit', to: 'profiles#update', as: 'update_profile'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "static_pages#home"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
