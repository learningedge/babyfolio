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
    seen_behaviours = current_child.max_seen_by_category

    uniq_ages = seen_behaviours.map{ |b| b.age_from }.uniq.sort
    @lengths = Hash.new
    if uniq_ages.size == 1
      @lengths[uniq_ages[0]] = 125
    else
      uniq_ages.each_with_index.map { |i, index| @lengths[i] =  200/(uniq_ages.size).to_f * (index +1) }
    end

#<<<<<<< HEAD
##<<<<<<< HEAD
##    @avg_answers = categorized_qs.map{|k,v| v}
##    unless @avg_answers.first.age == @avg_answers.last.age
##        @weak_answers = [@avg_answers.pop]
##        @str_answers = [@avg_answers.shift]
##=======
#    third_from_start = seen_behaviours[2]
#    third_from_end = seen_behaviours[-3]
#=======
    first_str = seen_behaviours[0]
    last_weak = seen_behaviours[-1]
#>>>>>>> watch section updated to the new db - gutto

    seen_behaviours = seen_behaviours.group_by{|q| q.category}
    seen_behaviours.each do |k,v|
      seen_behaviours[k] = v.first
    end
    
    @str_answers = seen_behaviours.reject{ |k,v| v.age_from != first_str.age_from } unless first_str.nil?
    @weak_answers = seen_behaviours.reject{ |k,v| v.age_from != last_weak.age_from } unless last_weak.nil?
    @avg_answers = seen_behaviours
    @avg_answers = seen_behaviours.reject{|k,v| @str_answers.keys.include?(k)} if @str_answers.present?
    @avg_answers = @avg_answers.reject{|k,v| @weak_answers.keys.include?(k)} if @weak_answers.present?

    @empty_answers = ActiveSupport::OrderedHash.new
    Behaviour::CATEGORIES.each do |k,v|
      @empty_answers[k] = nil if seen_behaviours[k].nil?
#>>>>>>> reworking db scheme , watch still to be done - gitt
    end
    @avg_answers = @avg_answers.sort_by{|q| Question::CATS_ORDER.index(q.category)  }.sort_by{|q| q.age}.reverse

    @empty_answers = []
    Question::CATS_ORDER.each do |k,v|
      @empty_answers << k if categorized_qs[k].nil?
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
    
    seen_behaviours = current_child.max_seen_by_category
      
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
#<<<<<<< HEAD
#    ms = []
#<<<<<<< HEAD
#    @behaviours = []
#    current_questions = []
#
#    questions = current_child.max_seen_by_category
#
#
#    questions.each do |q|
#      question = Question.get_next_questions_for_category(q.category, q.age, 1).first
#      current_questions << (question || q)
#    end
#
#    if params[:mid]
#      m = Milestone.includes(:questions).find_by_mid(params[:mid])
#    end
#
#    current_questions.each do |q|
#      if m.present? && q.category == m.questions.first.category
#        time = q.age > m.questions.first.age ? "past" : (q.age < m.questions.first.age ? "future" : "current")
#        ms  << { :category => m.questions.first.category, :milestone => m, :time => time }
#      else
#        ms  << {:category => q.category, :milestone => q.milestone, :time => "current", :is_next => Question.get_next_questions_for_category(q.category,q.age,1).first.present? }
#=======
#=======
#>>>>>>> watch section updated to the new db - gutto
    @behaviours = []    

    curr_b = Behaviour.includes(:activities).find_by_id(params[:bid]) if params[:bid].present?
    seen_behaviours = current_child.max_seen_by_category

    seen_behaviours.each do |b|
      beh = Behaviour.includes(:activities).find_by_category(b.category, :conditions => ["age_from > ?", b.age_from], :order => "age_from ASC")
      time = "current"
      
      if curr_b && b.category == curr_b.category
#<<<<<<< HEAD
#        beh = curr_b
#        time = curr_b.age_from > beh.age_from ? "future" : "past"
##>>>>>>> reworking db scheme , watch still to be done - gitt
#=======
        time = "future" if curr_b.age_from > beh.age_from
        beh = curr_b        
#>>>>>>> watch section updated to the new db - gutto
      end

      unless beh
        beh = b
      end

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
                       :selected => selected
                     }
#<<<<<<< HEAD
#    end
#
#    ms.each do |m|
#        if m[:milestone]
#          selected = m[:milestone].mid == params[:mid]
#          @behaviours << {
#                           :category => m[:category],
#                           :mid => m[:milestone].mid,
#                           :ms_title => current_child.replace_forms(m[:milestone].title, 35),
#                           :title => current_child.replace_forms(m[:milestone].get_title, 60),
#                           :subtitle =>  m[:milestone].observation_subtitle.blank? ? "Subtitle goes here" : current_child.replace_forms(m[:milestone].observation_subtitle),
#                           :desc => current_child.replace_forms(m[:milestone].observation_desc),
#                           :examples =>  current_child.replace_forms(m[:milestone].other_occurances),
#                           :activity_1_title => current_child.replace_forms(m[:milestone].activity_1_title, 40),
#                           :activity_2_title => current_child.replace_forms(m[:milestone].activity_2_title, 40),
#                           :activity_1_url => play_children_path(:mid => m[:milestone].mid, :no => 1),
#                           :activity_2_url => play_children_path(:mid => m[:milestone].mid, :no => 2),
#                           :why_important => current_child.replace_forms(m[:milestone].observation_what_it_means),
#                           :theory => current_child.replace_forms(m[:milestone].research_background),
#                           :references => current_child.replace_forms(m[:milestone].research_references),
#                           :time => m[:time],
#                           :is_next => m[:is_next],
#                           :selected => selected || false
#                          }
#        end
#=======
#>>>>>>> watch section updated to the new db - gutto
    end
    @behaviours.first[:selected] = true unless @behaviours.any? { |b| b[:selected] == true }
  end

  def get_adjacent_behaviour
    ref_b = Behaviour.includes(:activities).find_by_id(params[:bid])
    
    curr_b = current_child.behaviours.find_by_category(ref_b.category, :order => 'age_from DESC')
    max_b = Behaviour.includes(:activities).find_by_category(curr_b.category, :conditions => ["age_from > ?", curr_b.age_from], :order => "age_from ASC")

    if params[:dir] == 'prev'
      dir = "<"
      order = "DESC"
    else
      dir = ">"
      order = "ASC"
    end

#<<<<<<< HEAD
#    qs = Question.includes(:milestone).find_by_category(ms.questions.first.category, :conditions => ["questions.age #{dir} ?", ms.questions.first.age], :order => "questions.age #{order}", :limit => 1)
#    max_ans_age = current_child.questions.where(["questions.category = ? ", qs.category]).order('questions.age DESC').limit(1).first.age
#    qs_current = Question.includes(:milestone).find_by_category(ms.questions.first.category, :conditions => ["questions.age >= ?", max_ans_age], :order => "questions.age ASC", :limit => 1)
#
#    if qs_current && qs_current.age < qs.age
#      time = "future"
#    elsif qs_current && qs_current.age >= qs.age
#=======
    beh = Behaviour.find_by_category(ref_b.category, :conditions => ["age_from #{dir} ?", ref_b.age_from], :order => "age_from #{order}")
    
    if beh            
#>>>>>>> watch section updated to the new db - gutto
      time = "past"
      if max_b && max_b.age_from == beh.age_from
        time = "current"
      elsif max_b && beh.age_from > max_b.age_from
        time = "future"
      end

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
                         :selected => true
                }
        respond_to do |format|
          format.html { render :partial => "watch_single", :locals => { :item => item, :time => time} }
        end
    else

#<<<<<<< HEAD
#    item =  {
#               :category => qs.category,
#               :mid => qs.mid,
#               :ms_title => current_child.replace_forms(qs.milestone.title, 35),
#               :title =>  current_child.replace_forms(qs.milestone.get_title, 60),
#               :subtitle =>  qs.milestone.observation_subtitle.blank? ? "Subtitle goes here" : current_child.replace_forms(qs.milestone.observation_subtitle),
#               :desc => current_child.replace_forms(qs.milestone.observation_desc),
#               :examples =>  current_child.replace_forms(qs.milestone.other_occurances),
#               :activity_1_title => current_child.replace_forms(qs.milestone.activity_1_title, 40),
#               :activity_2_title => current_child.replace_forms(qs.milestone.activity_2_title, 40),
#               :activity_1_url => play_children_path(:mid => qs.mid, :no => 1),
#               :activity_2_url => play_children_path(:mid => qs.mid, :no => 2),
#               :why_important => current_child.replace_forms(qs.milestone.observation_what_it_means),
#               :theory => current_child.replace_forms(qs.milestone.research_background),
#               :references => current_child.replace_forms(qs.milestone.research_references),
#               :selected => true,
#               :is_next => Question.get_next_questions_for_category(qs.category,qs.age,1).first.present?
#              }
#              respond_to do |format|
#                format.html { render :partial => "watch_single", :locals => { :item => item, :time => time} }
#              end
#=======
    end
#>>>>>>> watch section updated to the new db - gutto
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
