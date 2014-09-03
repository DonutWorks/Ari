Rails.application.routes.draw do
  resources :gates
  root 'gate#new'
end
