Rails.application.routes.draw do
  get 'dashboard/index'
  namespace :api, defaults: { format:'json' } do
    get 'gifs', to: 'gifs#show'
  end
  match '/', to: 'home#index', via: 'get', as: 'home'
  match 'search', to: 'search#index', via: [:get, :post], as: 'search'
  match 'search/found/', to: 'search#show', via: 'get', as: 'show_search'
  match 'search/slack/', to: 'search#slack', via: [:get, :post], as: 'slack_search'
  match 'dashboard', to: 'dashboard#index', via: 'get', as: 'dashboard'
  match 'dashboard/settings', to: 'dashboard#settings', via: 'get', as: 'dashboard_settings'
  match 'dashboard/api', to: 'dashboard#api', via: 'get', as: 'dashboard_api'
  match 'dashboard/get_token', to: 'dashboard#get_token', via: 'post', as: 'get_token'
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  resources :teams, only: [:create, :destroy, :update]
  root 'home#index'
end
