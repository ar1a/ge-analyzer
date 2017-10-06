Rails.application.routes.draw do


  authenticated :user do
    root 'home#index'
    resources :items, only: %i[show]
    get 'items/:id/daily', to: 'items#daily', as: 'daily'
  end
  root 'welcome#index'

  devise_for :users
end
