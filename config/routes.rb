Rails.application.routes.draw do
  get 'dashboard/index'

  root 'home#index'
  match '/', to: 'home#index', via: 'get', as: 'home'
  match 'search', to: 'search#index', via: [:get, :post], as: 'search'
  match 'search/found/', to: 'search#show', via: 'get', as: 'show_search'
  match 'search/slack/', to: 'search#slack', via: [:get, :post], as: 'slack_search'
  match 'dashboard', to: 'dashboard#index', via: 'get', as: 'dashboard'
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
end
