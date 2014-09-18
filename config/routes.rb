Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :show, :destroy]
  
  root 'sessions#show', id: 1

  resources :gates, only: [:show]

  namespace :admin do
    root 'application#index'

    resources :users, except: [:new, :create]
    resource :import, controller: :import,  only: [:new, :create]
    resources :gates do
      collection do
        get 'download_roster_example'
      end
    end
    resources :user, controller: "users/registrations", only: [:new, :create]

    resource :export_excel,  controller: :export_excel,  only: [:new, :create]
  end
end