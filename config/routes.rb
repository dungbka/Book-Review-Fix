Rails.application.routes.draw do
  resources :categories
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users
  resources :books do
    resources :reviews do
      resources :comments
    end
  end

  post 'create_comment', to: 'comments#create_comment', as: 'create_comment'

  resources :reviews
  resources :votes, only: [:create, :destroy]

  scope "(:locale)", locale: /en|ja/ do
    root to: 'books#index'
  end

  root 'books#index'

  post 'update_status', to: 'notifications#update_status', as: 'update_status'
end
