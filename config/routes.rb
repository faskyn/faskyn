require 'sidekiq/web'

Rails.application.routes.draw do

  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/about', path: 'about'
  get 'static_pages/help', path: 'help'
  get 'static_pages/privacypolicy', path: 'privacypolicy'
  get 'application/google7df1f819c8dc9008', path: 'google7df1f819c8dc9008'

  post 'pusher/auth' #for pusher authentication
  get '/auth/:provider/callback', to: 'socials#create' #twitter/linkedin/angellist/google
  resources :contacts
  devise_for :users
  resources :users do
    resources :eventnamecompanies
    resources :events, only: :index
    #more custom notification routes down
    resources :notifications, only: [:create, :index]
    resource :profile do
      resources :socials, only: [:create, :update, :destroy]
    end
    resources :tasknamecompanies
    resources :tasks do
      member do
        patch :complete, :uncomplete
      end
      collection do
        get :incoming_tasks, :outgoing_tasks, :completed_tasks, :completed_incoming_tasks, :completed_outgoing_tasks
      end
    end
  end
  get 'users/:user_id/common_medias', to: 'common_medias#common_medias', as: :common_medias_user_common_medias
  get 'users/:user_id/common_medias/get_files', to: 'common_medias#get_files', as: :get_files_user_common_medias
  get 'users/:user_id/common_medias/get_links', to: 'common_medias#get_links', as: :get_links_user_common_medias
  get 'users/:user_id/common_medias/get_calendars', to: 'common_medias#get_calendars', as: :get_calendars_user_common_medias
  get 'users/:user_id/chat_notifications', to: 'notifications#chat_notifications', as: :chat_notifications_user_notifications
  get 'users/:user_id/other_notifications', to: 'notifications#other_notifications', as: :other_notifications_user_notifications

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:index, :create]
  end

  mount Sidekiq::Web => '/sidekiq'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
