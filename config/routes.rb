Rails.application.routes.draw do


  authenticated :user do
    root 'home#index'
    resources :item, only: %i[show]
  end
  root 'welcome#index'

  devise_for :users
end
