Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'import' => 'import_excel#import'
  get 'destroy' => 'import_excel#destroy'

  resources :gates, only: [:show]

  namespace :admin do
    root 'application#index'

    resources :gates, only: [:new, :create, :show] do
      collection do
        get 'download_roster_example'
      end
    end

    resource :export_excel,  controller: :export_excel,  only: [:new, :create]

    get 'import' => 'gates#import'

    post 'add_members' => 'gates#add_members'
  end

end
