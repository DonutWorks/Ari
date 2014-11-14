Rails.application.routes.draw do
  root to: 'application#index'

  get 'demo', to: 'demo#show'

  resources :providers, path: '/auth/:provider', only: [] do # oauth callback
    collection do
      get 'callback', to: :create
    end
  end

  devise_for :admin_users, path: ':club_id/admin'

  get 'sign_in', to: 'sessions#new'
  post 'auth', to: 'sessions#auth_without_club'
  resources :clubs, only: [:show], path: '/' do
    resources :invitations, only: [:new, :create, :show], param: :code

    get 'sign_in', to: 'sessions#new'
    post 'auth', to: 'sessions#create'
    get 'sign_out', to: 'sessions#destroy'

    resources :notices, only: [:show] do
      resources :responses
      resources :to_responses
      resources :checklists, shallow: true do
        get 'finish'
        resources :assignee_comments
      end
    end

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
      root 'activities#index'

      resources :activities

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


        member do
          get 'to_notice_end_deadline'
          patch 'to_notice_change_deadline'
        end


        resources :responses, only: [] do
          collection do
            get '/', to: :index
            post '/', to: :update
            get '/update_check', to: :update_check
          end
        end
      end


      resources :bank_accounts do
        get 'download_account_example', on: :collection
        resources :expense_records do
          get 'submit_dues'
        end
      end

      resource :export_excel,  controller: :export_excel,  only: [:new, :create]
      resources :messages
    end
  end

  get '/gates/:id', to:  redirect('/notices/%{id}')

  # for back compatibility
  resources :notices, only: [] do
    collection do
      get '/:id(/*rest)', to: (redirect do |path_params, req|
        notice = Notice.find_by_id(path_params[:id])
        "#{notice.club.friendly_id}/notices/#{notice.friendly_id}/#{path_params[:rest]}"
      end)
    end
  end
end
