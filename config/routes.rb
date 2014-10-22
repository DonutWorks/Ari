Rails.application.routes.draw do
  resources :providers, path: '/auth/:provider', only: [] do # oauth callback
    collection do
      get 'callback', to: :create
    end
  end

  # for back compatibility
  resources :notices, only: [:show] do
    resources :responses
    resources :to_responses
  end


  devise_for :admins, path: ':club_id/admin'
  resources :clubs, only: [:show], path: '/' do
    resources :invitations, only: [:new, :create, :show], param: :code

    get 'sign_in', to: 'sessions#new'
    post 'auth', to: 'sessions#create'
    get 'sign_out', to: 'sessions#destroy'

    resources :users, only: [] do
      collection do
        get 'show'
      end
    end

    resources :notices, only: [:show] do
      resources :responses
      resources :to_responses
    end

    namespace :admin do
      root 'application#index'

      resources :users do
        collection do
          get :import, to: 'import#new'
          post :import, to: 'import#create'
        end
      end

      resources :notices do
        collection do
          get 'download_roster_example'
        end
        resources :responses, only: [] do
          collection do
            get '/', to: :index
            post '/', to: :update
          end
        end
      end

      resource :export_excel,  controller: :export_excel,  only: [:new, :create]
      resources :messages
    end
  end
  get '/gates/:id', to:  redirect('/notices/%{id}')

end
