Rails.application.routes.draw do
  # authenticated :user do
  root 'home#index'
  get 'items/home', to: 'home#index'
  get 'items/:id/daily', to: 'items#daily', as: 'daily'
  get 'items/:id/three', to: 'items#three', as: 'three'
  get 'items/:id/week', to: 'items#week', as: 'week'
  get 'items/:id/month', to: 'items#month', as: 'month'
  post 'items/:id/refresh', to: 'items#refresh', as: 'refresh'
  get 'items/search', to: 'home#search', as: 'items_search'
  put 'items/sort_by/:method', to: 'home#sort_by', as: 'items_sort_by'
  put 'items/:id/favourite', to: 'items#favourite', as: 'favourite'
  resources :items, only: %i[show]
  scope :groups do
    get 'most_traded', to: 'home#most_traded', as: 'most_traded'
    get 'top_flips', to: 'home#top_flips', as: 'top_flips'
    get 'barrows_items', to: 'home#barrows_items', as: 'barrows_items'
    get 'zulrah', to: 'home#zulrah', as: 'zulrah'
    get 'potions', to: 'home#potions', as: 'potions'
    get 'ores', to: 'home#ores', as: 'ores'
    get 'food', to: 'home#food', as: 'food'
    get 'free', to: 'home#free', as: 'free'
    get 'favourited', to: 'home#favourited', as: 'favourited'
  end
  # end
  # root 'welcome#index'
  get 'sitemap', to: 'home#sitemap'

  devise_for :users, controllers: { registrations: 'registrations' }
end
