Rails.application.routes.draw do
  root 'home#index'
  match '/', to: 'home#index', via: 'get', as: 'home_path'
  match 'search', to: 'search#index', via: [:get, :post], as: 'search_path'
  match 'search/found/', to: 'search#show', via: 'get', as: 'show_search_path'
  match 'search/slack/', to: 'search#slack', via: 'post', as: 'slack_search_path'
end
