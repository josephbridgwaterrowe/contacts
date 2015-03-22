Rails.application.routes.draw do
  devise_for :users,
             skip: [:registrations]
  # devise_scope :user do
  #   match '/users/sign_out', as: :destroy_user_session, to: 'devise/sessions#destroy', via: :delete
  # end

  root to: 'contacts#index'

  resources :contacts, only: [:index, :show]

  namespace :admin do
    resources :users
  end

  namespace :configuration do
    resources :contacts
  end
end
