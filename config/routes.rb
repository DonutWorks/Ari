Rails.application.routes.draw do
  root 'users#show', id: 1

  resources :invitations, only: [:new, :create, :show], param: :code # email activation
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

  resources :notices, only: [:show] do
    resources :responses
    resources :to_responses
    resources :checklists, shallow: true do 
      get 'finish'
      resources :assignee_comments
    end
  end

  namespace :admin do
    root 'application#index'
    get 'users/get_user'

    resources :users do
      collection do
        get :import, to: 'import#new'
        post :import, to: 'import#create'
        get '/tags/(:tag_name)', to: :tags, defaults: {format: 'json'}, constraints: { search_word: /.*/ }
        get '/search/(:search_word)', to: :search, defaults: {format: 'json'}, constraints: { search_word: /.*/ }
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
          get '/update_check', to: :update_check
        end
      end

    end

    resource :export_excel,  controller: :export_excel,  only: [:new, :create]

    resources :messages
  end
  get '/gates/:id', to:  redirect('/notices/%{id}')
end
