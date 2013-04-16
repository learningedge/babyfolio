# -*- coding: utf-8 -*-
class ChildrenController < ApplicationController
  layout "child", :only => [:reflect, :play, :watch]
  before_filter :require_user
  before_filter :require_child, :except => [:new,:create,:create_photo]
  before_filter :require_seen_behaviours, :except => [:new,:create,:create_photo]

  def switch_child
    child = current_user.children.find_by_id(params[:child])
    set_current_child child.id if child
    redirect_to params[:request_uri]
  end

  def new
    @page = Page.find_by_slug("signup_step_2")
    @child = Child.new
    @child.last_name = current_user.last_name if current_user.last_name.present?
    destination_family = Family.find_by_id(params[:family_id])
    @destination_family_id = destination_family.id if destination_family
  end

  def create
    @child = Child.new(params[:child])
    @child.media = MediaImage.find_by_id(params[:child_profile_media])    
    if @child.valid?
      # ==> add new relation for user and all family admins/members
      Family.user_added_child(current_user, @child, params[:relation_type], params[:family_id], params[:family_name])

      set_current_child @child.id
      redirect_to registration_initial_questionnaire_path
    else
      @destination_family = Family.find_by_id(params[:family_id])
      render :action => 'new'
    end
  end

  def create_photo
    size = params[:size].to_sym if params[:size]
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

    current_user.media.find(params[:previous_img]).delete if params[:previous_img]
    media = MediaImage.create(:image => tempfile, :user => current_user)
    respond_to do |format|
      format.html { render :text => "{\"success\":\"true\", \"media_id\":\"#{media.id}\", \"img_url\":\"#{media.image.url(size || :profile_medium)}\"}" }      
    end
  end

  def destroy
    relation = Relation.includes([:child => :family]).find_by_user_id_and_child_id(current_user.id, params[:child_id])
    family_id = relation.child.family.id

    if relation && relation.is_admin
      relation.child.destroy_child
      clear_current_child
    end

    redirect_to settings_tab_path(:tab => "my_family", :family_id => family_id)
  end

  def reflect
    seen_behaviours = current_child.max_seen_by_cat

    uniq_ages = seen_behaviours.map{ |b| b.age_from }.uniq.sort
    @lengths = Hash.new
    if uniq_ages.size == 1
      @lengths[uniq_ages[0]] = 125
    else
      uniq_ages.each_with_index.map { |i, index| @lengths[i] =  200/(uniq_ages.size).to_f * (index +1) }
    end    

    @avg_answers = seen_behaviours

    @empty_answers = []
    Behaviour::CATEGORIES_ORDER.each do |cat|      
      @empty_answers << cat unless seen_behaviours.any?{|sb| sb.category == cat}
    end

    if false && @avg_answers.first.age_from != @avg_answers.last.age_from
        @weak_answers = [@avg_answers.pop]
        @str_answers = [@avg_answers.shift]
    end    

    @str_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}’s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Strength - <span class='bold'>#{current_child.first_name}</span> is developing more quickly at <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Continue to strengthen this strength.</p>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. Watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <p><ParentingTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")
      
    @avg_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @weak_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}’s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Area for Improvement: <span class='bold'>#{current_child.first_name}</span> is developing less quickly in <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Development naturally spurts and lags in all areas. Keep watching for opportunities to bolster #his/her# <INTELLIGENCE> development.</p>
                  <p>TIP: Recently <span class='bold'>#{current_child.first_name}</span> <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @reflect_visited = current_user.done_action?('reflect_visited')
    current_user.do_action!('reflect_visited')

  end

  def play
    @activities = []
    
    if params[:aid]
      curr_a = Activity.includes(:behaviour).find_by_id(params[:aid])
    end
    
    seen_behaviours = current_child.max_seen_by_cat
    
    seen_behaviours.each do |sb|
      if curr_a.nil? || sb.category != curr_a.category
        a = sb.activities.first
      else
        a = curr_a          
      end
      selected = a.id == params[:aid].to_i ? true : false
      a_likes = a.likes.find_by_child_id(current_child.id)
      likes = a_likes.value unless a_likes.nil?
      @activities << {
        :category => a.category,
        :aid => a.id,
        :b_title => current_child.replace_forms(a.behaviour.title_past),
        :bid => a.behaviour.id,
        :title => current_child.replace_forms(a.title),
        :action => current_child.replace_forms(a.action),
        :actioned => current_child.replace_forms(a.actioned),
        :desc_short => current_child.replace_forms(a.description_short),
        :desc_long => current_child.replace_forms(a.description_long),
        :variation1 => current_child.replace_forms(a.variation1),
        :variation2 => current_child.replace_forms(a.variation2),                         
        :learning_benefit => current_child.replace_forms(a.learning_benefit),
        :selected => selected || false,
        :likes => likes
      }
    end
    @activities.first[:selected] = true unless @activities.any? { |a| a[:selected] == true }
  end

  def get_adjacent_activity 
    curr_a = Activity.includes(:behaviour).find_by_id(params[:aid])

    if params[:dir] == 'prev'
      dir = "<"
      order = "DESC"
    else
      dir = ">"
      order = "ASC"
    end

    new_a = Activity.find_by_category(curr_a.category, :conditions => ["age_from #{dir} ?", curr_a.age_from], :order => "age_from #{order}")
    curr_b = current_child.behaviours.find_by_category(curr_a.category, :order => 'age_from DESC')
    time = "current"
    time = "past" if new_a.age_from < curr_b.age_from
    time = "future" if new_a.age_from > curr_b.age_from

    ms_likes = new_a.likes.find_by_child_id(current_child.id)
    likes = ms_likes.value unless ms_likes.nil?
    item =  {

                         :category => new_a.category,
                         :aid => new_a.id,
                         :b_title => current_child.replace_forms(new_a.behaviour.title_past),
                         :bid => new_a.behaviour.id,
                         :title => current_child.replace_forms(new_a.title),
                         :action => current_child.replace_forms(new_a.action),
                         :actioned => current_child.replace_forms(new_a.actioned),
                         :desc_short => current_child.replace_forms(new_a.description_short),
                         :desc_long => current_child.replace_forms(new_a.description_long),
                         :variation1 => current_child.replace_forms(new_a.variation1),
                         :variation2 => current_child.replace_forms(new_a.variation2),
                         :learning_benefit => current_child.replace_forms(new_a.learning_benefit),
                         :selected => true,
                         :likes => likes                         
              }
    respond_to do |format|
      format.html { render :partial => "play_single", :locals => { :a => item, :time => time, :aid => new_a.id, :bid => nil} }
    end
  end

  def activity_like
    a_object_id = Activity.find_by_id(params[:aid]).id
    l = Like.find_or_initialize_by_child_id_and_activity_id(current_child.id, a_object_id)
    l.value = params[:likes]
    l.save
    render :text => "Done for #{params[:aid]}"
  end

  def watch
    @behaviours = []    

    curr_b = Behaviour.includes(:activities).find_by_id(params[:bid]) if params[:bid].present?
    seen_behaviours = current_child.max_seen_by_cat;
    @seen_behaviours = seen_behaviours;

    seen_behaviours.each do |b|
      beh = Behaviour.includes(:activities).find_by_category(b.category, :conditions => ["age_from > ?", b.age_from], :order => "age_from ASC")
      time = "current"     
      
      if curr_b && b.category == curr_b.category
        time = "future" if curr_b.age_from > beh.age_from
        beh = curr_b        
      end

      unless beh
        beh = b
      end

      checked = current_child.seen_behaviours.find_by_behaviour_id(beh.id) ? true : false
      time = "past" if beh.age_from <= b.age_from
      
      selected = beh.id == params[:bid].to_i ? true : false
      @behaviours << {
                       :category => beh.category,
                       :time => time,
                       :bid => beh.id,
                       :title => current_child.replace_forms(beh.title_present),
                       :title_past => current_child.replace_forms(beh.title_past),
                       :desc_short => current_child.replace_forms(beh.description_short),
                       :desc_long => current_child.replace_forms(beh.description_long),
                       :example1 => current_child.replace_forms(beh.example1),
                       :example2 => current_child.replace_forms(beh.example2),
                       :example3 => current_child.replace_forms(beh.example3),
                       :activities => beh.activities,
                       :why_important => current_child.replace_forms(beh.why_important),
                       :parenting_tip1 => current_child.replace_forms(beh.parenting_tip1),
                       :parenting_tip2 => current_child.replace_forms(beh.parenting_tip2),
                       :theory => current_child.replace_forms(beh.theory),
                       :references => current_child.replace_forms(beh.references),
                       :selected => selected,
                       :checked => checked
                     }
    end
    @behaviours.first[:selected] = true unless @behaviours.any? { |b| b[:selected] == true }
  end

  def get_adjacent_behaviour
    ref_b = Behaviour.includes(:activities).find_by_id(params[:bid])
    
    curr_b = current_child.behaviours.find_by_category(ref_b.category, :order => 'age_from DESC')
    max_b = Behaviour.includes(:activities).find_by_category(curr_b.category, :conditions => ["age_from > ?", curr_b.age_from], :order => "age_from ASC") if curr_b
    
    if params[:dir] == 'prev'
      dir = "<"
      order = "DESC"
    else
      dir = ">"
      order = "ASC"
    end
    
    beh = Behaviour.find_by_category(ref_b.category, :conditions => ["age_from #{dir} ?", ref_b.age_from], :order => "age_from #{order}, id ASC")
    beh ||= ref_b
    
    
    if beh            
      time = "past"
      if max_b && max_b.age_from == beh.age_from
        time = "current"
      elsif max_b && beh.age_from > max_b.age_from
        time = "future"
      end
      checked = current_child.seen_behaviours.find_by_behaviour_id(beh.id) ? true : false
      item =  {
        :category => beh.category,
        :time => time,
        :bid => beh.id,
        :title => current_child.replace_forms(beh.title_present),
        :title_past => current_child.replace_forms(beh.title_past),
        :desc_short => current_child.replace_forms(beh.description_short),
        :desc_long => current_child.replace_forms(beh.description_long),
        :example1 => current_child.replace_forms(beh.example1),
        :example2 => current_child.replace_forms(beh.example2),
        :example3 => current_child.replace_forms(beh.example3),
        :activities => beh.activities,
        :why_important => current_child.replace_forms(beh.why_important),
        :parenting_tip1 => current_child.replace_forms(beh.parenting_tip1),
        :parenting_tip2 => current_child.replace_forms(beh.parenting_tip2),
        :theory => current_child.replace_forms(beh.theory),
        :references => current_child.replace_forms(beh.references),
        :selected => true,
        :checked => checked
      }
      respond_to do |format|
        format.html { render :partial => "watch_single", :locals => { :item => item, :time => time} }
      end
    end 
  end
  
  
  def edit
    @child = Child.find(params[:id])
    flash[:tab] = 'my_family'
    render :layout => "child"
  end
  
  def update
    relation = current_user.relations.includes(:child).find_by_child_id(params[:id])
    relation.child.assign_attributes(params[:child])    
    relation.child.media = Media.find_by_id(params[:child_profile_media])
    relation.member_type = params[:relation_type]
    if relation.save
      flash.now[:notice] = "Child sucessfully updated"
      redirect_to settings_path(:family_id => relation.child.family.id)
    else
      @child = relation.child
      render :edit, :layout => "child"
    end   
  end
 
end
