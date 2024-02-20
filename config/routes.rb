Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users, path: '',
                     controllers: { registrations: 'users/registrations' },
                     skip: 'registrations'

  devise_scope :user do
    get 'cancel', to: 'users/registrations#cancel', as: 'cancel_user_registration'
    get 'sign_up', to: 'users/registrations#new', as: 'new_user_registration'
    get 'edit_credentials', to: 'users/registrations#edit', as: 'edit_user_registration'
    patch 'edit_credentials', to: 'users/registrations#update', as: 'user_registration'
    put 'edit_credentials', to: 'users/registrations#update'
    post 'edit_credentials', to: 'users/registrations#create'
    delete 'edit_credentials', to: 'users/registrations#destroy'
  end

  get 'edit_profile', to: 'profiles#edit', as: 'edit_profile'
  put 'edit_profile', to: 'profiles#update', as: 'update_profile'

  resources :pickles
  resources :journals, only: [:index, :create, :destroy]

  get ':username', to: 'users#show', as: 'user'

  root to: "static_pages#home"
end
