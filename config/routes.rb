Rails.application.routes.draw do
  root 'users#show', id: 1

  get '/auth/:provider/callback', as: 'oauth_callback', to: 'sessions#create'
  resources :users, only: [] do
    collection do
      get 'show'
      get 'sign_in', to: 'sessions#new'
      get 'auth', to: 'sessions#create'
      get 'sign_out', to: 'sessions#destroy'
      get 'sign_up', to: 'users#new'
      post 'sign_up', to: 'users#create'
      get 'verify/:code', to: 'users#verify', as: 'verify_code'
    end
  end

  resources :gates, only: [:show]

  namespace :admin do
    root 'application#index'

    resources :users do
      collection do
        get :import, to: 'import#new'
        post :import, to: 'import#create'
      end
    end

    resources :gates do
      collection do
        get 'download_roster_example'
      end
    end

    resource :export_excel,  controller: :export_excel,  only: [:new, :create]
  end
end
