class ChildrenController < ApplicationController
  layout "child", :only => [:reflect, :play]
  before_filter :require_user
  before_filter :require_child, :except => [:new,:create,:create_childs_photo]


  def new
    @child = Child.new    
  end

  def create
    @child = Child.new(params[:child])
    @child.media = MediaImage.find_by_id(params[:child_profile_media])

    if @child.save      
      rel = Relation.find_or_create_by_user_id_and_child_id(current_user.id, @child.id)
      rel.assign_attributes(:member_type => params[:relation_type], :accepted => 1, :token => current_user.perishable_token)
      rel.save
      current_user.reset_perishable_token!            
      set_current_child @child.id
      redirect_to initial_questionnaire_url
    else
      render :action => 'new'
    end
  end

  def create_childs_photo
    if params[:qqfile].kind_of? String
      ext = '.' + params[:qqfile].split('.').last
      fname = params[:qqfile].split(ext).first
      tempfile = Tempfile.new([fname, ext])
      tempfile.binmode
      tempfile << request.body.read
      tempfile.rewind
    else
      tempfile = params[:qqfile].tempfile
    end

    media = MediaImage.create(:image => tempfile)
    respond_to do |format|
      format.html { render :text => "{\"success\":\"true\", \"media_id\":\"#{media.id}\", \"img_url\":\"#{media.image.url(:upload_med)}\"}" }
    end
  end

  def reflect
    @answers = current_child.answers.includes(:question).find_all_by_value('seen').group_by{|a| a.question.category }
    @answers = @answers.sort_by{ |k,v| v.max_by{|a| a.question.age }.question.age }.reverse
    @answers.each do |k,v|
      max_age = v.max_by{ |a| a.question.age}.question.age      
      v.delete_if{|a| a.question.age != max_age}
    end

    third_from_start = @answers[2][1].first
    third_from_end = @answers[-3][1].first

    @str_answers = @answers.select{ |k,v| v.first.question.age > third_from_start.question.age }
    @weak_answers = @answers.select{ |k,v| v.first.question.age < third_from_end.question.age }
    @avg_answers = @answers - @str_answers - @weak_answers    
    
    @max = @answers.map{ |k,v| v.first.question.age }.max
    @min = @answers.map{ |k,v| v.first.question.age }.min
    @diff = @max - @min

    @str_text = "<h4>Strong Development</h4><p><span>#{ current_child.first_name}</span> is showing promise at <span><INTELLIGENCE> development</span> based on the behavioral milestones he has already exhibited.</p></p><p>The following play activities will further boost this development:</p><h5>Recommended Play Activities</h5>"
    @avg_text = "<h4>Average Development</h4><p><span>#{ current_child.first_name}</span> also shows <span><INTELLIGENCE> development</span> based on the behavioral milestones he has already exhibited.</p><p>Recently, #{current_child.first_name} pretended while playing.</p><p>Support his continuing social development with these activities below.</p><h5>Recommended Play Activities</h5>"
    @weak_text = "<h4>Needs Improvement in Development</h4><p><span>#{ current_child.first_name}</span> is currently slower to develop in <span><INTELLIGENCE> development</span> based on the behavioral milestones he has already exhibited.</p><p>Recently, #{current_child.first_name} Felt Worried or Sad After Making a Mistake.</p><p>Support his continuing emotional development with these activities below.</p><h5>Recommended Play Activities</h5>"

    @str_text = @str_text.gsub('<BABYNAME>', current_child.first_name)
    @avg_text = @avg_text.gsub('<BABYNAME>', current_child.first_name)
    @weak_text = @weak_text.gsub('<BABYNAME>', current_child.first_name)
  end

  def play    
    answers = current_child.answers.includes(:question).find_all_by_value('seen').group_by{|a| a.question.category }
    answers = answers.sort_by{ |k,v| v.max_by{|a| a.question.age }.question.age }
    answers.each do |k,v|
      max_age = v.max_by{ |a| a.question.age}.question.age
      v.delete_if{|a| a.question.age != max_age}
    end

    ms = []
    answers.each do |k,v|
      ms  << {:category => v.first.question.category, :milestone => Milestone.find_by_mid(v.map{|a| a.question.mid }) }
    end

    @activities = []
    ms.each do |ms|      
        @activities << { :category => ms[:category],
                         :mid => ms[:milestone].mid,
                         :ms_title => current_child.replace_forms(ms[:milestone].title, 35),
                         :title => current_child.replace_forms(ms[:milestone].activity_1_title, 60),
                         :setup => current_child.replace_forms(ms[:milestone].activity_1_set_up, 90),
                         :response => current_child.replace_forms(ms[:milestone].activity_1_response),
                         :variations => current_child.replace_forms(ms[:milestone].activity_1_modification),
                         :learning_benefits => current_child.replace_forms(ms[:milestone].activity_1_learning_benefits),
                        }      
    end

    
#    @total_activities = @activities.size
#
#    @per_page = 3
#    @page = (params[:page] ||= 1).to_i
#    @offset_start = (@page -1)* @per_page
#    @offset_end = @offset_start + @per_page -1
#    length = @activities[@offset_start..@offset_end].size
#    @offset_end = @offset_start + (length - 1)    
  end

  def get_adjacent_activity
    ms = Question.joins([:milestone,:answers])#.where(["answers.child_id = ? AND questions.mid = ? ", current_child.id, params[:mid]])
    render :text => ms.map{|m| m.mid}.join("<br />")
  end

  def show
    @user = current_user
    @children = current_user.relations.find_all_by_accepted(1, :conditions => ['child_id is not null'], :include => [:child]).map{|r| r.child}
    if session[:level] && session[:level][@selected_child.id]
      @level = session[:level][@selected_child.id]
    end

    @selected_child = @children.select{|c| c.id == params[:child_id].to_i }.first
    if @selected_child.present?
      set_current_child @selected_child.id
    else
      @selected_child = current_child
    end
    moments = @selected_child.moments

    @moments = moments.paginate(:page => params[:page])
  end

  def edit
    @child = Child.find(params[:id])    
  end

  def update
    relation = current_user.relations.includes(:child).find_by_child_id(params[:id])
    relation.child.assign_attributes(params[:child])    
    relation.child.media = Media.find_by_id(params[:child_profile_media])
    relation.member_type = params[:relation_type]
    if relation.save
      flash.now[:notice] = "Child sucessfully updated"
      redirect_to settings_path
    else
      @child = relation.child
      render :edit
    end

    
  end

  def add_friends
  end

  def add_family
  end

  def create_relations    
    @friends = params[:friends]
    user_emails = Array.new
    users = Array.new
    @error = false

    @friends = @friends.select{ |f| f[1]['email'].strip.present?}
    user_emails = @friends.map{|f| f[1]['email']}.uniq

    
    if user_emails.empty?
      @error = true
      @flash_error = "You need to enter at least one email";
    end

    unless @error
      exist_users = User.where(['email IN (?)', user_emails]).all      

      @friends.each do |f|
        idx = exist_users.find_index{|u| u.email == f[1]['email']}
        if idx
          @user = exist_users[idx]
        else
          @user = User.new(:email => f[1][:email])
          @user.reset_password
          @user.reset_perishable_token
          @user.reset_single_access_token
        end

        unless @user.valid?
            @error = true
            break
        end        
        @user.relations.find_or_initialize_by_child_id(current_child.id, :member_type => f[1][:member_type], :token => @user.perishable_token, :inviter => current_user)
        @user.reset_perishable_token
        users << @user
      end
    end
    
    unless @error
      users.each do |user|
        user.save
        UserMailer.invite_user(user.relations.first{|r| r.child_id == current_child.id}, current_user).deliver
      end
      flash[:notice] = "Thanks fo inviting others. We have successfully sent emails to the other family & friends that you entered."
      if params[:page] == 'add_family'
        redirect_to child_profile_children_path
      else
        redirect_to add_family_children_path
      end
    else      
      if params[:page] == 'add_friends'
        flash.now[:error] = "Invalid emails!"
        render :action => :add_friends
      else
        flash.now[:error] = "Invalid emails!"
        render :action => :add_family
      end
    end
  end


  def info
    if current_user.can_view_child? params[:id]
      @child = Child.find(params[:id])
    else
      respond_to do |format|
        format.html { redirect_to errors_permission_path }
      end
    end
  end
  
end
