Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
  
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    namespace :v1 do
      resources :users
      resources :items
      resources :keywords
      resources :subscriptions
      resources :keyword_lists

      ##### TESTING PURPOSE #####
      # Bulk import urls for 'keywords', 'users' and 'subscriptions'
      post 'keywords/import', to: 'keywords#import'
      post 'users/import', to: 'users#import'
      post 'subscriptions/import', to: 'subscriptions#import'
    end
  end

end
