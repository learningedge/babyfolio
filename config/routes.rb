Babyfolio::Application.routes.draw do

  namespace :admin do
    root :to => "dashboard#index"
    get "/" => "dashboard#index", :as => :dashboard_index
    post "/search" => "dashboard#search", :as => :search    
    resources :users, :only => [:index, :edit, :update] do
      collection do
        get '/:user_id/logs' => "users#logs", :as => :logs
      end
    end
    resources :families, :only => [:index, :edit, :update]
  end

  namespace :registration do
    post '/add-photos/flickr/photos' => "add_photos#flickr_photos", :as => :add_photos_flickr_photos
    post '/add-photos/flickr/sets' => "add_photos#flickr_sets", :as => :add_photos_flickr_sets
    post '/add-photos/facebook/photos' => "add_photos#facebook_photos", :as => :add_photos_facebook_photos
    post '/add-photos/facebook/sets' => "add_photos#facebook_albums", :as => :add_photos_facebook_albums
    post '/add-photos/photo' => "add_photos#photo", :as => :add_photos_photo
    post '/add-photos/create-photos' => "add_photos#create_photo", :as => :add_photos_create_photo
    post '/add-photos/import-media' => "add_photos#import_media", :as => :add_photos_import_media
    post '/add-photos/remove-moment' => "add_photos#remove_moment", :as => :remove_moment_import_media
    post '/add-photos/update-visibility' => "add_photos#update_visibility", :as => :update_visibility_import_media
    
    match '/add-videos/new-vimeo-video' => "add_videos#new_vimeo", :as => :add_videos_new_vimeo
    post '/add-videos/upload-vimeo-video' => "add_videos#upload_vimeo", :as => :add_videos_upload_vimeo
    post '/add-videos/iframe-upload' => "add_videos#iframe_upload", :as => :add_videos_iframe_upload
    match '/add-videos/new-youtube' => "add_videos#new_youtube", :as => :add_videos_new_youtube
    match '/add-videos/upload-youtube-video' => "add_videos#upload_youtube", :as => :add_videos_upload_youtube
    match '/add-videos/upload-file-youtube-video' => "add_videos#upload_file_youtube", :as => :add_videos_upload_file_youtube
    post '/add-videos/import-media' => "add_videos#import_media", :as => :add_videos_import_media
  end

    get '/user/settings' => "users#settings", :as => :settings
    match '/milestone' => "milestones#show", :as => :show_milestone
    match '/milestone/details/:mid/:child_id' => "milestones#show_full", :as => :show_milestone_details



  resources :moments, :except => [:new, :index] do
      new do
        post :change_provider
        get ':child_id' => "moments#new", :as => :child
        get ':child_id/milestone/:milestone_id' => "moments#new", :as => :child_milestone
      end
      
      collection do
        match 'import-images/:child_id' => "moments#import_media", :as => :import_media
        get 'import-videos/:child_id' => "moments#import_videos", :as => :import_videos
        post :create_from_media
        put '/tag_it/update' => "moments#update_moment_tags", :as => :update_tag
        get '/tag_it/:id' => "moments#tag_moment", :as => :tag
        put '/deepen_it/update' => "moments#update_deepen_it", :as => :update_deepen
        get '/deepen_it/:id' => "moments#deepen_it", :as => :deepen
        put '/connect_it/update' => "moments#update_connect_it", :as => :update_connect
        get '/connect_it/:id' => "moments#connect_it", :as => :connect
      end
  end



  resources :youtube, :only => [:new] do
    new do
      post :upload
      get :upload_video
    end
    collection do
      match :youtube_ajax, :as => :ajax
    end
  end
  
  resources :flickr, :only => [:index] do
    collection do
      match :flickr_ajax, :as => :ajax
      match :flickr_sets, :as => :sets
      match :flickr_photos, :as => :photos
    end
  end

  resources :vimeo, :only => [:index, :new] do
    new do
      get :vimeo_ajax, :as => :ajax
      post :upload 
    end
  end

  get "/errors/permission" => "errors#permission", :as => :errors_permission  

  get "questions/:child(/:level)" => "questions#index", :as => :questions
  get "initial_questionnaire" => "questions#initial_questionnaire", :as => :initial_questionnaire
  post "update_seen/:child_id/:question" => "questions#update_seen", :as => :update_seen
  post "update_initial_questionnaire" => "questions#update_initial_questionnaire", :as => :update_initial_questionnaire
  get "initial_questionnaire_completed" => "questions#initial_questionnaire_completed", :as => :initial_questionnaire_completed
  post "complete_questionnaire(/:level)" => "questions#complete_questionnaire", :as => :complete_questionnaire
#  post "complete_questionnaire/advanced" => "questions#complete_questionnaire_advanced"
#  post "complete_questionnaire/basic" => "questions#complete_questionnaire_basic"
  
  match "upload_image" => "uploaded_images#update", :as => :upload_image
  get "upload_image/index" => "uploaded_images#index", :as => :upload_image_index

  get "home/index"    

  match '/auth/you:service/callback' => 'services#create_youtube', :as => :youtube_connect
  match '/auth/fl:service/callback' => 'services#create_flickr', :as => :flickr_connect
  match '/auth/v:service/callback' => 'services#create_vimeo', :as => :vimeo_connect
  match '/auth/:service/callback' => 'services#create'
  match '/auth/failure' => 'services#failure'
  get 'service/disconnect' => 'services#disconnect', :as => :disconnect

  get "facebook" => "facebook#index"
  get "facebook_albums" => "facebook#albums"
  get "facebook_album_photos/:album" => "facebook#album_photos", :as => :album_photos  

  get "confirmation" => "confirmation#index", :as => :confirmation
  get "confirmation/resend" => "confirmation#re_send_email"
  get "confirmation/confirm_email"
  get "confirmation/accept_invitation" => "confirmation#accept_invitation"
  get "confirmation/accept_relations" => "confirmation#accept_relations"
  post "confirmation/update_relation" => "confirmation#update_relation"  
  put "confirmation/update_user" => "confirmation#update_user"
  

  get "reset-password/email" => "forgot_passwords#new", :as => :new_forgot_password
  post "reset-password/email/check" => "forgot_passwords#create", :as => :create_forgot_password
  get "reset-password/password" => "forgot_passwords#edit", :as => :edit_forgot_password
  put "reset-password/password/update" => "forgot_passwords#update", :as => :update_forgot_password

  match 'login' => "user_sessions#new", :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match 'signup' => "users#new", :as => :signup
  match 'create-profile-photo' => "users#create_profile_photo", :as => :create_profile_photo
  
  resources :children, :only => [:create, :edit, :update] do
    collection do
      get '/new' => "children#new", :as => :new_child
      get '/add_friends' => "children#add_friends", :as => :add_friends
      get '/add_family' => "children#add_family", :as => :add_family
      post '/create_relations' => "children#create_relations", :as => :create_relations
      post '/create-photo' => "children#create_photo", :as => :create_photo
      get '(:child_id)' => "children#timeline", :as => :timeline
      post '/add-timeline-entry' => "children#add_timeline_entry", :as => :add_timeline_entry
      get '/reflect' => "children#reflect", :as => :child_reflect
      get '/play(/:mid/:no)' => "children#play", :as => :play
      get '/watch(/:mid)' => "children#watch", :as => :watch
      get '/get-adjacent-activity/:mid/:dir' => "children#get_adjacent_activity", :as => :adjacent_activity
      get '/get-adjacent-behaviour/:mid/:dir' => "children#get_adjacent_behaviour", :as => :adjacent_behaviour
#      get ':child_id' => "children#show", :as => :child_profile
      get :show, :as => :child_profile
      get '/:id/info' => "children#info", :as => :info
    end
  end

  resources :relations, :only => [:destroy, :new, :create] do
      get 'make-admin' => "relations#make_admin", :as => :make_admin      
  end

  resources :user_sessions do
    collection do
      post :change_family
    end
  end
  
  resource :user, :as => 'account' do
    collection do
      get 'edit' => "users#edit"
      get 'image' => "users#add_image"
      put 'upload' => "users#upload_image"
      get 'change-password' => "users#change_password"
      put 'update-password' => "users#update_password"
      post 'create_temp_user' => "users#create_temp_user"
    end
  end

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
