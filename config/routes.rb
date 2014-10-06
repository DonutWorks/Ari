Rails.application.routes.draw do
  root 'users#show', id: 1

  resources :activations, only: [:new, :create, :show], param: :code # email activation
  resources :providers, path: '/auth/:provider', only: [] do # oauth callback
    collection do
      get 'callback', to: :create
    end
  end
  resources :users, only: [] do
    collection do
      get 'show'
      get 'sign_in', to: 'sessions#new'
      post 'auth', to: 'sessions#create'
      get 'sign_out', to: 'sessions#destroy'
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

    resources :messages
  end
end
