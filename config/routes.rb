Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :show, :destroy]

  root 'sessions#show', id: 1

  get '/auth/:provider/callback', to: 'users#auth'
  resources :users, only: [] do
    collection do
      get 'show'
      get 'sign_in', to: 'users#sign_in'
      get 'sign_up', to: 'users#new'
      post 'sign_up', to: 'users#create'
      get 'email_sent', to: 'users#email_sent'
      get 'verify/:code', to: 'users#verify'
    end
  end

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
