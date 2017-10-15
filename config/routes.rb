Rails.application.routes.draw do
  root 'home#index'
  resources :items, only: %i[show]
  get 'items/:id/daily', to: 'items#daily', as: 'daily'
  get 'items/:id/three', to: 'items#three', as: 'three'
  get 'items/:id/week', to: 'items#week', as: 'week'
  get 'items/:id/month', to: 'items#month', as: 'month'
  post 'items/:id/refresh', to: 'items#refresh', as: 'refresh'
  authenticated :user, ->(user) { user.username == 'ar1a' } do
    mount Blazer::Engine, at: 'blazer'
  end
  # root 'welcome#index'

  devise_for :users
end
