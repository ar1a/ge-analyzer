Rails.application.routes.draw do
  # authenticated :user do
  root 'home#index'
  resources :items, only: %i[show]
  get 'items/:id/daily', to: 'items#daily', as: 'daily'
  get 'items/:id/three', to: 'items#three', as: 'three'
  get 'items/:id/week', to: 'items#week', as: 'week'
  get 'items/:id/month', to: 'items#month', as: 'month'
  post 'items/:id/refresh', to: 'items#refresh', as: 'refresh'
  get 'most_traded', to: 'home#most_traded', as: 'most_traded'
  get 'top_flips', to: 'home#top_flips', as: 'top_flips'
  get 'barrows_items', to: 'home#barrows_items', as: 'barrows_items'
  get 'zulrah', to: 'home#zulrah', as: 'zulrah'
  # end
  # root 'welcome#index'

  devise_for :users, controllers: { registrations: 'registrations' }
end
