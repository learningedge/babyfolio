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

  get '/user/settings/invite(/:family_id)' => "users#settings", :as => :settings_invite, :defaults => { :is_invite => true }
  post '/user/settings/update_zipcode(/:family_id)' => "users#update_zipcode", :as => :update_user_zipcode
  get '/user/settings/tab/:tab(/:family_id)' => "users#settings_tab", :as => :settings_tab
  get '/user/settings/about_me(/:tab)' => "users#settings", :as => :settings_about, :defaults => { :is_about_me => true}
  get '/user/settings(/:family_id)' => "users#settings", :as => :settings  
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
  post "update_seen/:behaviour/:start_age/:value" => "questions#update_seen", :as => :update_seen
  post "update_watch/:bid" => "questions#update_watched", :as => :update_watched
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
      get '/add(/:family_id)' => "children#new", :as => :new_child
      delete '/delete/:child_id' => "children#destroy", :as => :delete_child
#      get '/add_friends' => "children#add_friends", :as => :add_friends
#      get '/add_family' => "children#add_family", :as => :add_family
      post '/create_relations' => "children#create_relations", :as => :create_relations
      post '/create-photo' => "children#create_photo", :as => :create_photo            
      get '/reflect' => "children#reflect", :as => :child_reflect
      get '/play(/:aid)' => "children#play", :as => :play
      get '/watch(/:bid)' => "children#watch", :as => :watch
      get '/get-adjacent-activity/:aid/:dir' => "children#get_adjacent_activity", :as => :adjacent_activity
      post '/activity-like' => "children#activity_like", :as => :activity_like
      get '/get-adjacent-behaviour/:bid/:dir' => "children#get_adjacent_behaviour", :as => :adjacent_behaviour
      get '/:id/info' => "children#info", :as => :info
    end
  end

  # TIMELINE
  get 'timeline/error' => "timeline#error", :as => :error_timeline
  post 'timeline/add-timeline-entry' => "timeline#add_entry", :as => :add_timeline_entry
  post 'timeline/add-basic-timeline-entry' => "timeline#add_from_popup", :as => :add_basic_entry
  post 'timeline/reflect_to_timeline' => "timeline#reflect_to_timeline", :as => :reflect_to_timeline
  post 'timeline/add-comment' => "timeline#add_comment", :as => :add_timeline_comment
  post 'timeline/invite' => "timeline#invite_redirect", :as => :timeline_invite_redirect
  post 'timeline/remind_later' => "timeline#remind_later", :as => :timeline_remind_later
  post 'timeline/dont_remind' => "timeline#dont_remind", :as => :timeline_dont_remind
  get 'timeline' => "timeline#show_timeline", :as => :show_timeline
  get 'visit-timeline/:child_id' => "timeline#visit_timeline", :as => :visit_timeline
  # TIMELINE 


#  RELATIONS
#  resources :relations, :only => [:destroy, :create] do
#  end
#  get 'new-relation/:child_id' => "relations#new", :as => :new_relation
#  RELATIONS

#  FAMILIES
    post 'invite-users' => "families#invite_users", :as => :invite_users
    get 'invitations-form' => "families#show_invitations_form", :as => :show_invitations_form
    get 'make-admin' => "families#make_admin", :as => :make_admin
    get 'remove-admin' => "families#remove_admin", :as => :remove_admin
    delete 'remove-user-from-family' => "families#remove_user", :as => :remove_user
    post 'change-family' => "families#change_family", :as => :change_family
    post 'update-access/:child_id/:user_id' => "families#update_access", :as => :update_access
    get 'resend-invitation/:relation_id' =>  "families#resend_invitation", :as => :resend_invitation
    get 'rescind-invitation/:relation_id' =>  "families#rescind_invitation", :as => :rescind_invitation
    get 'edit-family-relation/:relation_id' => "families#edit_relation", :as => :edit_relation
    post 'update-family-relation' => "families#update_relation", :as => :update_relation
#  FAMILIES


  
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
      get 'deactivate-user' => "users#deactivate_user", :as => :deactivate_user
      post 'deactivate-user-survey' => "users#deactivate_user_survey", :as => :deactivate_user_survey
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
        post 'name_and_pic' => "users#name_and_pic"
      end

      resource :children, :only => [:create] do
        get 'current' => "children#current"
        post 'change_current/:id' => "children#change_current"
        get 'play' => "children#play"
        get 'play/adjacent/:mid/:dir' => "children#get_adjacent_activity"
        get 'watch' => "children#watch"
        get 'watch/adjacent/:mid/:dir' => "children#get_adjacent_behaviour"
        get 'reflect' => "children#reflect"
      end

      get "timeline" => "timeline#index"
      get "watch/:mid" => "watch#show"
      get "play/:mid" => "play#show"
      get "reflect/:cat" => "reflect#show"
      post "timeline/add_entry" => "timeline#add_entry"
      post "timeline/comment" => "timeline#add_comment"
        
      #  QUESTIONS
      get "questionnaire/initial" => "questions#initial_questionnaire", :as => :initial_questionnaire
      post "not_seen" => "questions#not_seen"
      post "update_seen/:child_id/:question/:start_age/:value" => "questions#update_seen", :as => :update_seen
      post "update_watch/:mid" => "questions#update_watched", :as => :update_watched
      post "update_initial_questionnaire" => "questions#update_initial_questionnaire", :as => :update_initial_questionnaire
      get "initial_questionnaire_completed/(:add_child)" => "questions#initial_questionnaire_completed", :as => :initial_questionnaire_completed

    end
  end
#  API

  root :to => "home#index"
  
end
