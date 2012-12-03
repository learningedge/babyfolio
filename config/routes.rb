Babyfolio::Application.routes.draw do

#  namespace :admin do
#    root :to => "dashboard#index"
#    get "/" => "dashboard#index", :as => :dashboard_index
#    post "/search" => "dashboard#search", :as => :search
#    resources :users, :only => [:index, :edit, :update] do
#      collection do
#        get '/:user_id/logs' => "users#logs", :as => :logs
#      end
#    end
#    resources :families, :only => [:index, :edit, :update]
#  end

  get '/user/settings' => "users#settings", :as => :settings  
  get "/errors/permission" => "errors#permission", :as => :errors_permission
  get "home/index"    

#  QUESTIONNAIRES
  get "questionnaire/initial" => "questions#initial_questionnaire", :as => :initial_questionnaire
  post "update_seen/:child_id/:question/:start_age/:value" => "questions#update_seen", :as => :update_seen
  post "update_initial_questionnaire" => "questions#update_initial_questionnaire", :as => :update_initial_questionnaire
  get "initial_questionnaire_completed" => "questions#initial_questionnaire_completed", :as => :initial_questionnaire_completed
#  QUESTIONNAIRES

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

  resources :user_sessions do
  end

  resources :children, :only => [:create, :edit, :update] do
    collection do
      get '/new' => "children#new", :as => :new_child
      get '/add_friends' => "children#add_friends", :as => :add_friends
      get '/add_family' => "children#add_family", :as => :add_family
      post '/create_relations' => "children#create_relations", :as => :create_relations
      post '/create-photo' => "children#create_photo", :as => :create_photo            
      get '/reflect' => "children#reflect", :as => :child_reflect
      get '/play(/:mid/:no)' => "children#play", :as => :play
      get '/watch(/:mid)' => "children#watch", :as => :watch
      get '/get-adjacent-activity/:mid/:dir' => "children#get_adjacent_activity", :as => :adjacent_activity
      post '/activity-like' => "children#activity_like", :as => :activity_like
      get '/get-adjacent-behaviour/:mid/:dir' => "children#get_adjacent_behaviour", :as => :adjacent_behaviour
      get '/:id/info' => "children#info", :as => :info
    end
  end

  # TIMELINE
  post 'timeline/add-timeline-entry' => "timeline#add_entry", :as => :add_timeline_entry
  post 'timeline/add-basic-timeline-entry' => "timeline#add_from_popup", :as => :add_basic_entry
  post 'timeline/reflect_to_timeline' => "timeline#reflect_to_timeline", :as => :reflect_to_timeline
  post 'timeline/add-comment' => "timeline#add_comment", :as => :add_timeline_comment
  get 'timeline/(:child_id)' => "timeline#show", :as => :show_timeline

  # TIMELINE 


#  RELATIONS
  resources :relations, :only => [:destroy, :create] do      
      get 'make-admin' => "relations#make_admin", :as => :make_admin
  end
  get 'new-relation/:child_id' => "relations#new", :as => :new_relation
#  RELATIONS
  
#  USERS
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
#  USERS    

  root :to => "home#index"
  
end
