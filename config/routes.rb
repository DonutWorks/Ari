Rails.application.routes.draw do

  devise_for :users, only: [:session]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :gates, only: [:show]

  namespace :admin do
    root 'application#index'

    resource :import, controller: :import,  only: [:new, :create]
    resources :gates, only: [:new, :create, :show] do
      collection do
        get 'download_roster_example'
      end
    end
    resources :user, controller: "users/registrations", only: [:new, :create]

    resource :export_excel,  controller: :export_excel,  only: [:new, :create]
  end
end