Rails.application.routes.draw do
  get 'dashboard/index'
  namespace :api do
    match 'gifs/:q', to: 'gifs#show', via: 'get'
  end
  match '/', to: 'home#index', via: 'get', as: 'home'
  match 'search', to: 'search#index', via: [:get, :post], as: 'search'
  match 'search/found/', to: 'search#show', via: 'get', as: 'show_search'
  match 'search/slack/', to: 'search#slack', via: [:get, :post], as: 'slack_search'
  match 'dashboard', to: 'dashboard#index', via: 'get', as: 'dashboard'
  match 'dashboard/settings', to: 'dashboard#settings', via: 'get', as: 'dashboard_settings'
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  resources :teams, only: [:create, :destroy, :update]
  root 'home#index'
end
