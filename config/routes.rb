Rails.application.routes.draw do
  devise_for :users,
             skip: [:registrations]

  root to: 'contacts#index'

  resources :contacts, :only => [:index, :show]
  resources :departments, :only => [:index]

  namespace :admin do
    resources :users
  end

  namespace :configuration do
    resources :companies
    resources :contacts
    resources :departments
  end
end
