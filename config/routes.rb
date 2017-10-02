Rails.application.routes.draw do

  authenticated :user do
    root 'home#index'
  end
  root 'welcome#index'

  devise_for :users
end
