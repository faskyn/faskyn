require 'sidekiq/web'

Rails.application.routes.draw do

  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/about', path: 'about'
  get 'static_pages/help', path: 'help'
  get 'static_pages/privacypolicy', path: 'privacypolicy'
  get 'application/google7df1f819c8dc9008', path: 'google7df1f819c8dc9008'

  post 'pusher/auth' #for pusher authentication
  get '/auth/:provider/callback', to: 'socials#create' #twitter/linkedin/angellist
  get '/auth/failure', to: redirect('/')
  resources :contacts
  devise_for :users
  resources :users do
    resources :eventnamecompanies
    resources :events
    resources :notifications, only: [:create, :index] do
      collection do
        get :other_notifications, :chat_notifications
      end
    end
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

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:index, :create]
  end

  mount Sidekiq::Web => '/sidekiq'

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

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
