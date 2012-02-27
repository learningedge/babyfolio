Babyfolio::Application.routes.draw do

  resources :families, :only => [:new, :create, :index, :edit, :update] do
    collection do
      get :add_friends
      get :add_children
      match :create_friend_relations

      match :create_friends
      get :relations
      post :create_relations
      post :change_family_to_edit
    end
  end
    
  get "home/index"
  get "interior" => "home#interior", :as => :interior

  get "confirmation" => "confirmation#index", :as => :confirmation
  get "confirmation/resend" => "confirmation#re_send_email"
  get "confirmation/confirm_email"
  get "confirmation/accept_invitation" => "confirmation#accept_invitation"
  put "confirmation/update_user" => "confirmation#update_user"
  
  get "reset-password/email" => "forgot_passwords#new", :as => :new_forgot_password
  post "reset-password/email/check" => "forgot_passwords#create", :as => :create_forgot_password
  get "reset-password/password" => "forgot_passwords#edit", :as => :edit_forgot_password
  put "reset-password/password/update" => "forgot_passwords#update", :as => :update_forgot_password

  resources :user_sessions do
    collection do
      post :change_family
    end
  end
  
  match 'login' => "user_sessions#new", :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  resources :users  # give us our some normal resource routes for users
  resource :user, :as => 'account'  # a convenience route

  match 'signup' => "users#new", :as => :signup


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  root :to => "home#index"
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
