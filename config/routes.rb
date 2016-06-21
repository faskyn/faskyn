require 'sidekiq/web'

Rails.application.routes.draw do

  authenticated :user do
    root 'posts#index', as: :authenticated_root
  end
  root 'static_pages#home'

  get 'foo/bar'
  
  get 'static_pages/home'
  get 'static_pages/about', path: 'about'
  get 'static_pages/help', path: 'help'
  get 'static_pages/privacypolicy', path: 'privacypolicy'
  get 'application/google7df1f819c8dc9008', path: 'google7df1f819c8dc9008'

  post 'pusher/auth' #for pusher authentication
  get '/auth/:provider/callback', to: 'socials#create' #twitter/linkedin
  resources :contacts, only: [:new, :create]
  devise_for :users
  resources :users, only: [:index, :show] do
    #more custom notification routes down
    resource :profile, except: :destroy do 
      member do
        get :add_socials
      end
    end
    
    resources :tasks, except: [:new, :show] do
      member do
        patch :complete, :uncomplete
      end
      collection do
        get :incoming_tasks, :outgoing_tasks, :completed_tasks, :completed_incoming_tasks, :completed_outgoing_tasks
      end
    end
  end

  resources :tasknamecompanies, only: :index
  resources :socials, only: [:create, :update, :destroy]

  resources :conversations, only: [] do
    resources :messages, only: :create
  end

  resources :posts do
    resources :comments, only: :create, module: :posts #polymorphic
  end

  resources :products do
    resources :product_owner_panels, only: :index, module: :products
    resources :group_invitations, only: [:new, :create], module: :products #polymorphic
    resources :product_users, only: :destroy, module: :products
    resources :comments, only: :create, module: :products #polymorphic
    resources :product_customers, only: [:show], module: :products #create/update/delete is nested attr
    resources :product_leads, only: :show, module: :products #create/update/delete is nested attr 
  end

  resources :group_invitations, only: :destroy do
    member do
      patch :accept
    end
  end

  resources :product_customers, only: [] do
    resources :product_customer_users, only: :destroy, module: :product_customers
    resources :group_invitations, only: :create, module: :product_customers #polymorphic
    resources :comments, only: :create, module: :product_customers #polymorphic
    resources :reviews, only: :create
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :product_leads, only: [] do
    resources :comments, only: :create, module: :product_leads #polymorphic
  end

  resources :comments, only: [:update, :destroy] do 
    resources :comment_replies, only: [:create, :update, :destroy], module: :comments
  end

  get 'users/:user_id/common_medias', to: 'common_medias#common_medias', as: :common_medias_user_common_medias
  get 'users/:user_id/common_medias/get_files', to: 'common_medias#get_files', as: :get_files_user_common_medias
  get 'users/:user_id/common_medias/get_links', to: 'common_medias#get_links', as: :get_links_user_common_medias

  get 'users/:user_id/chat_notifications', to: 'notifications#chat_notifications', as: :chat_notifications_user_notifications
  get 'users/:user_id/other_notifications', to: 'notifications#other_notifications', as: :other_notifications_user_notifications
  get 'users/:user_id/chat_notifications_dropdown', to: 'notifications#chat_notifications_dropdown', as: :chat_notifications_dropdown_user_notifications
  get 'users/:user_id/other_notifications_dropdown', to: 'notifications#other_notifications_dropdown', as: :other_notifications_dropdown_user_notifications
  get 'users/:user_id/checking_decreasing', to: 'notifications#checking_decreasing', as: :checking_decreasing_user_notifications

  get 'users/:user_id/products', to: 'products#own_products', as: :products_user_products

  authenticate :user, lambda { |u| u.email == "szilard.magyar@gmail.com" } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
