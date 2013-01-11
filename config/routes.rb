Babyfolio::Application.routes.draw do

  namespace :admin do
    root :to => "users#index"
    get "/" => "dashboard#index", :as => :dashboard_index
    post "/search" => "dashboard#search", :as => :search
    resources :users, :only => [:index, :edit, :update] do
      collection do
        get '/:user_id/logs' => "users#logs", :as => :logs
      end
    end    
  end

  get '/user/settings/invite' => "users#settings", :as => :settings_invite, :defaults => { :is_invite => true }
  get '/user/settings(/:chid)' => "users#settings", :as => :settings
  get "/errors/permission" => "errors#permission", :as => :errors_permission
  get "home/index"
  get "contact" => "home#contact", :as => :contact, :defaults => { :is_contact => true }
  get "about" => "home#about", :as => :about
  get "privacy-policy" => "home#privacy", :as => :privacy
  post "send-contact" => "home#send_contact", :as => :send_contact

  #REGISTRATION  SPECIFIC
    get "registration/children/new" => "children#new", :as => :registration_new_child, :defaults => { :is_registration => true }
    get "registration/questionnaire/initial" => "questions#initial_questionnaire", :as => :registration_initial_questionnaire , :defaults => { :is_registration => true }    
  #REGISTRATION  SPECIFIC
    
#  QUESTIONNAIRES
  get "questionnaire/initial" => "questions#initial_questionnaire", :as => :initial_questionnaire
  post "update_seen/:child_id/:question/:start_age/:value" => "questions#update_seen", :as => :update_seen
  post "update_watch/:mid" => "questions#update_watched", :as => :update_watched
  post "update_initial_questionnaire" => "questions#update_initial_questionnaire", :as => :update_initial_questionnaire
  get "initial_questionnaire_completed/(:add_child)" => "questions#initial_questionnaire_completed", :as => :initial_questionnaire_completed
#  QUESTIONNAIRES

  get "confirmation" => "confirmation#index", :as => :confirmation
  get "confirmation/resend" => "confirmation#re_send_email"
#  get "confirmation/confirm_email"
  get "confirmation/email_confirmed" => "confirmation#email_confirmed", :as => :email_confirmed
  get "confirmation/accept_invitation" => "confirmation#accept_invitation"
  get "confirmation/accept_relations" => "confirmation#accept_relations"
  post "confirmation/update_relation" => "confirmation#update_relation"  
  put "confirmation/update_user" => "confirmation#update_user"

  
  get "reset-password/email" => "forgot_passwords#new", :as => :new_forgot_password
  post "reset-password/email/check" => "forgot_passwords#create", :as => :create_forgot_password
  get "reset-password/password" => "forgot_passwords#edit", :as => :edit_forgot_password
  get "reset-password/email-sent" => "forgot_passwords#reset_done", :as => :reset_done
  put "reset-password/password/update" => "forgot_passwords#update", :as => :update_forgot_password

  match 'login' => "user_sessions#new", :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout
  match 'signup' => "users#new", :as => :signup
  match 'create-profile-photo' => "users#create_profile_photo", :as => :create_profile_photo

  resources :user_sessions do    
  end

  resources :children, :only => [:create, :edit, :update] do
    collection do
      get 'change-child' => "children#switch_child", :as => :switch
      get '/add' => "children#new", :as => :new_child
#      get '/add_friends' => "children#add_friends", :as => :add_friends
#      get '/add_family' => "children#add_family", :as => :add_family
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
  get 'timeline/(:child_id)' => "timeline#show_timeline", :as => :show_timeline

  # TIMELINE 


#  RELATIONS
  resources :relations, :only => [:destroy, :create] do      
      get 'make-admin' => "relations#make_admin", :as => :make_admin
  end
  get 'new-relation/:child_id' => "relations#new", :as => :new_relation
  post 'invite-users' => "relations#invite_users", :as => :invite_users
  get 'invitations-form' => "relations#show_invitations_form", :as => :show_invitations_form
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
      get '/unsubscribe/:token' => "users#unsubscribe", :as => :unsubscribe
    end    
  end
#  USERS    

#  API
  namespace :api do
    namespace :v1 do
      resource :users do
        get 'current' => "users#current"
        post 'login' => "users#login"
        post 'logout' => "users#logout"
      end

      resource :children, :only => [:create] do
        get 'current' => "children#current"
        get 'play' => "children#play"
        get 'play/adjacent/:mid/:dir' => "children#get_adjacent_activity"
        get 'watch' => "children#watch"
        get 'watch/adjacent/:mid/:dir' => "children#get_adjacent_behaviour"
        get 'reflect' => "children#reflect"
      end
    end
  end
#  API

  root :to => "home#index"
  
end
