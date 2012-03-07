class ServicesController < ApplicationController

  
  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every service

      # create a new hash
      @authhash = Hash.new

      if service_route == 'facebook'
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['info']['first_name'] ? @authhash[:first_name] =  omniauth['info']['first_name'] : @authhash[:first_name] = ''
        omniauth['info']['last_name'] ? @authhash[:last_name] =  omniauth['info']['last_name'] : @authhash[:last_name] = ''
        omniauth['uid'] ?  @authhash[:uid] =  omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['credentials']['token'] ? @authhash[:token] = omniauth['credentials']['token'] : authhash[:token] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
        #    elsif service_route == 'github'
        #      omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        #      omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        #      omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        #      omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''
        #    elsif ['google', 'yahoo', 'twitter', 'myopenid', 'open_id'].index(service_route) != nil
        #      omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        #      omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        #      omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        #      omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
     else
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end

      if @authhash[:uid] != '' and @authhash[:provider] != ''

        auth = Service.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        # if the user is currently signed in, he/she might want to add another account to signin
        if current_user
          if auth
            flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
            auth.update_attribute(:token, @authhash[:token]) unless auth.token == @authhash[:token]
             @redirect_link = child_profile_children_url
	  else 
            if(current_user.has_facebook_account?) do 
                flash[:notice] = "You have other " +  @authhash[:provider].capitalize + " connected. Disconnect your previeous account from setting before adding new one".
                @redirect_link = child_profile_children_url
            else 
              current_user.services.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email], :token => @authhash[:token])
              flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
              @redirect_link = child_profile_children_url
            end
          end
        else
          if auth
            # signin existing user
            # in the session his user id and the service id used for signing in is stored
            UserSession.create(User.find(auth.user_id))
            auth.update_attribute(:token, @authhash[:token]) unless auth.token == @authhash[:token]
            flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
            @redirect_link = child_profile_children_url
          else
            @user = User.find_by_email(@authhash[:email])
            unless @user
            	@user = User.new(:email => @authhash[:email], :email_confirmed => 1)			
	    	@user.reset_password
            	@user.reset_perishable_token
	    end
	    @user.first_name ||= @authhash[:first_name]
            @user.last_name ||= @authhash[:last_name]
	    @user.services.build(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email], :token => @authhash[:token])
	    if @user.save
              # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
              UserSession.create(@user)
              @redirect_link = child_profile_children_url
            else 	    
              flash[:error] = 'There were some problems siging in with your facebook accout.'
              @redirect_link = login_url
	    end
          end
        end
      else
        flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        @redirect_link = login_url
      end
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
      @redirect_link = login_url
    end

  end

  def create_youtube
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    render :text => request.env

    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    # routes are defined like this => '/auth/you:service/callback

    if omniauth and params[:service] == 'tube'
      # map the returned hashes to our variables first - the hashes differs for every service

      # create a new hash
      @authhash = Hash.new

      omniauth['info']['email'] ? @authhash[:uemail] =  omniauth['info']['email'] : @authhash[:email] = ''
      omniauth['info']['nickname'] ? @authhash[:uname] =  omniauth['info']['nickname'] : @authhash[:name] = ''
      omniauth['uid'] ? @authhash[:uid] = omniauth['uid']['$t'].to_s.split('/').last : @authhash[:uid] = ''
      omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      omniauth['credentials']['token'] ? @authhash[:token] = omniauth['credentials']['token'] : @authhash[:token] = ''
      omniauth['credentials']['secret'] ? @authhash[:secret] = omniauth['credentials']['secret'] : @authhash[:secret] = ''

      @service = Service.find_or_create_by_provider_and_uid(@authhash[:provider], @authhash[:uid])
      @service.update_attributes :token => @authhash[:token], :uname => @authhash[:uname], :user_id => current_user.id, :secret => @authhash[:secret]
      @service.save
      
      @redirect_link = youtube_index_url

      #render :create
      
    else
      render :text => service_route
      return
    end

  end



  def failure
    
    unless request.env['rack.session']['oauth']['youtube'].nil?

      flash[:error] = "Unable to authenticate user. If you are new on the YouTube  try to create the new channel first and then reconnect, in another case try to connect later"
      @redirect_link = connect_youtube_index_path

    else
      flash[:error] = 'Unable to authenticate user.'
      @redirect_link = '/'
    end

    render :action => :create

  end


end
