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

    #render :layout => "child" unless params[:is_registration]
  end

  def create
    @child = Child.new(params[:child])
    @child.media = MediaImage.find_by_id(params[:child_profile_media])    

    if @child.save
      rel = Relation.find_or_create_by_user_id_and_child_id(current_user.id, @child.id)
      rel.assign_attributes(:member_type => params[:relation_type], :accepted => 1, :token => current_user.perishable_token, :is_admin => true)
      rel.save
      current_user.reset_perishable_token!            
      set_current_child @child.id
      redirect_to registration_initial_questionnaire_path
    else
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

  def reflect
    categorized_qs = current_child.max_seen_by_category.group_by{|q| q.category}
    categorized_qs.each do |k,v|
      categorized_qs[k] = v.first
    end

    uniq_ages = categorized_qs.map{ |k,v| v.age }.uniq.sort
    @lengths = Hash.new
    if uniq_ages.size == 1
      @lengths[uniq_ages[0]] = 125
    else
      uniq_ages.each_with_index.map { |i, index| @lengths[i] =  200/(uniq_ages.size).to_f * (index +1) }
    end

    first_str = categorized_qs.values[0]
    last_weak = categorized_qs.values[-1]
    
    @str_answers = categorized_qs.reject{ |k,v| v.age != first_str.age } unless first_str.nil?
    @weak_answers = categorized_qs.reject{ |k,v| v.age != last_weak.age } unless last_weak.nil?
    @avg_answers = categorized_qs
    @avg_answers = categorized_qs.reject{|k,v| @str_answers.keys.include?(k)} if @str_answers.present?
    @avg_answers = @avg_answers.reject{|k,v| @weak_answers.keys.include?(k)} if @weak_answers.present?

    @empty_answers = ActiveSupport::OrderedHash.new
    Question::CATS.each do |k,v|
      @empty_answers[k] = nil if categorized_qs[k].nil?
    end
    
    @str_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}’s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Strength - #{current_child.first_name} is developing more quickly at <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Continue to strengthen this strength.</p>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. Watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <p><ParentingTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")
      
    @avg_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}'s Most Important <INTELLIGENCE> Development</h4>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")

    @weak_text = current_child.replace_forms("
                  <h4><WTitle>: #{current_child.first_name}’s Most Important <INTELLIGENCE> Development</h4>
                  <p>Current Area for Improvement: #{current_child.first_name} is developing less quickly in <INTELLIGENCE> development based on the actual behaviors #he/she# has already exhibited. Development naturally spurts and lags in all areas. Keep watching for opportunities to bolster #his/her# <INTELLIGENCE> development.</p>
                  <p>TIP: Recently #{current_child.first_name} <WTitlePast>. So watch for this behavior and exercise it as much as possible. Here is a parenting tip to take advantage of this “Learning Window” and help build a strong <INTELLIGENCE> foundation:</p>
                  <p><PTip></p>
                  <h5>Here are specific examples and play activities we recommend:</h5>")
  end

  def play
    answers = current_child.answers.includes(:question).find_all_by_value('seen').group_by{|a| a.question.category }
    answers = answers.sort_by{ |k,v| v.max_by{|a| a.question.age }.question.age }
    answers.each do |k,v|
      max_age = v.max_by{ |a| a.question.age}.question.age
      v.delete_if{|a| a.question.age != max_age}
    end
  
    if params[:mid]
      m = Milestone.includes(:questions).find_by_mid(params[:mid])
    end
    
    ms = []
    answers.each do |k,v|
      if m.blank? || v.first.question.category != m.questions.first.category
        ms  << {:category => v.first.question.category, :milestone => v.first.question.milestone }
      else
        ms  << { :category => m.questions.first.category, :milestone => m }
      end
    end              

    @activities = []
    ms.each do |ms|
        selected = true if ms[:milestone].mid == params[:mid]
        ms_likes = ms[:milestone].likes.find_by_child_id(current_child.id)
        likes = ms_likes.value unless ms_likes.nil?
        @activities << {
                         :category => ms[:category],
                         :mid => ms[:milestone].mid,
                         :ms_title => current_child.replace_forms(ms[:milestone].title, 35),
                         :title => ms[:milestone].activity_1_title.present? ? current_child.replace_forms(ms[:milestone].activity_1_title, 60) : "Title goes here",
                         :setup => current_child.replace_forms(ms[:milestone].activity_1_set_up, 90),
                         :response => current_child.replace_forms(ms[:milestone].activity_1_response),
                         :variations => current_child.replace_forms(ms[:milestone].activity_1_modification),
                         :learning_benefits => current_child.replace_forms(ms[:milestone].activity_1_learning_benefits),
                         :selected => selected || false,
                         :likes => likes
                        }
    end
    @activities.first[:selected] = true unless @activities.any? { |a| a[:selected] == true }
  end

  

  def get_adjacent_activity 
    ms = Milestone.includes(:questions).find_by_mid(params[:mid])    

    if params[:dir] == 'prev'
      dir = "<"
      order = "DESC"
    else
      dir = ">"
      order = "ASC"
    end

    qs = Question.where(["age #{dir} ? AND questions.category = ? ", ms.questions.first.age, ms.questions.first.category ]).order("age #{order}").limit(1).first
    age = current_child.answers.joins(:question).includes(:question).where(["questions.category = ? ", qs.category]).order('questions.age DESC').first.question.age
    if age < qs.age
      time = "future"
    elsif age > qs.age
      time = "past"
    else
      time = "current"
    end

    ms_likes = qs.milestone.likes.find_by_child_id(current_child.id)
    likes = ms_likes.value unless ms_likes.nil?
    item =  {
               :category => qs.category,
               :mid => qs.milestone.mid,               
               :ms_title => current_child.replace_forms(qs.milestone.title, 35),
               :title => qs.milestone.activity_1_title.blank? ? "Title goes here" : current_child.replace_forms(qs.milestone.activity_1_title, 60),
               :setup => current_child.replace_forms(qs.milestone.activity_1_set_up, 90),
               :response => current_child.replace_forms(qs.milestone.activity_1_response),
               :variations => current_child.replace_forms(qs.milestone.activity_1_modification),
               :learning_benefits => current_child.replace_forms(qs.milestone.activity_1_learning_benefits),
               :selected => true,
               :likes => likes
              }
              respond_to do |format|
                format.html { render :partial => "play_single", :locals => { :a => item, :time => time} }
              end    
  end

  def activity_like
    m_object_id = Milestone.find_by_mid(params[:mid]).id
    l = Like.find_or_initialize_by_child_id_and_activity_id(current_child.id, m_object_id)
    l.value = params[:likes]
    l.save
    render :text => "Done for #{params[:mid]}"
  end

  def watch
    ms = []
    @behaviours = []
    current_questions = []

    questions = current_child.max_seen_by_category

    questions.each do |q|      
      current_questions << Question.includes(:milestone).find_by_category(q.category, :conditions => ["questions.age > ?", q.age], :order => "questions.age ASC", :limit => 1)
    end        

    if params[:mid]
      m = Milestone.includes(:questions).find_by_mid(params[:mid])
    end

    current_questions.each do |q|
      if m.blank? || q.category != m.questions.first.category
        ms  << {:category => q.category, :milestone => q.milestone, :time => "current" }
      else
        time = q.age > m.questions.first.age ? "past" : (q.age < m.questions.first.age ? "future" : "current")
        ms  << { :category => m.questions.first.category, :milestone => m, :time => time }
      end
    end

    ms.each do |m|
        selected = true if m[:milestone].mid == params[:mid]
        @behaviours << {
                         :category => m[:category],
                         :mid => m[:milestone].mid,
                         :ms_title => current_child.replace_forms(m[:milestone].title, 35),
                         :title => current_child.replace_forms(m[:milestone].get_title, 60),
                         :subtitle =>  m[:milestone].observation_subtitle.blank? ? "Subtitle goes here" : current_child.replace_forms(m[:milestone].observation_subtitle),
                         :desc => current_child.replace_forms(m[:milestone].observation_desc),
                         :examples =>  current_child.replace_forms(m[:milestone].other_occurances),
                         :activity_1_title => current_child.replace_forms(m[:milestone].activity_1_title, 40),
                         :activity_2_title => current_child.replace_forms(m[:milestone].activity_2_title, 40),
                         :activity_1_url => play_children_path(:mid => m[:milestone].mid, :no => 1),
                         :activity_2_url => play_children_path(:mid => m[:milestone].mid, :no => 2),
                         :why_important => current_child.replace_forms(m[:milestone].observation_what_it_means),
                         :theory => current_child.replace_forms(m[:milestone].research_background),
                         :references => current_child.replace_forms(m[:milestone].research_references),
                         :time => m[:time],
                         :selected => selected || false
                        }
    end
    @behaviours.first[:selected] = true unless @behaviours.any? { |a| a[:selected] == true }

#    render :text => questions.first.age.to_s + " " + ms[-1][:milestone].questions.first.age.to_s
  end

  def get_adjacent_behaviour
    ms = Milestone.includes(:questions).find_by_mid(params[:mid])

    if params[:dir] == 'prev'
      dir = "<"
      order = "DESC"
    else
      dir = ">"
      order = "ASC"
    end

    qs = Question.includes(:milestone).find_by_category(ms.questions.first.category, :conditions => ["questions.age #{dir} ?", ms.questions.first.age], :order => "questions.age #{order}", :limit => 1)
    max_ans_age = current_child.questions.where(["questions.category = ? ", qs.category]).order('questions.age DESC').limit(1).first.age
    qs_current = Question.includes(:milestone).find_by_category(ms.questions.first.category, :conditions => ["questions.age > ?", max_ans_age], :order => "questions.age ASC", :limit => 1)
    
    if qs_current.age < qs.age
      time = "future"
    elsif qs_current.age > qs.age
      time = "past"
    else
      time = "current"
    end

    item =  {
               :category => qs.category,
               :mid => qs.mid,
               :ms_title => current_child.replace_forms(qs.milestone.title, 35),
               :title =>  current_child.replace_forms(qs.milestone.get_title, 60),
               :subtitle =>  qs.milestone.observation_subtitle.blank? ? "Subtitle goes here" : current_child.replace_forms(qs.milestone.observation_subtitle),
               :desc => current_child.replace_forms(qs.milestone.observation_desc),
               :examples =>  current_child.replace_forms(qs.milestone.other_occurances),
               :activity_1_title => current_child.replace_forms(qs.milestone.activity_1_title, 40),
               :activity_2_title => current_child.replace_forms(qs.milestone.activity_2_title, 40),
               :activity_1_url => play_children_path(:mid => qs.mid, :no => 1),
               :activity_2_url => play_children_path(:mid => qs.mid, :no => 2),
               :why_important => current_child.replace_forms(qs.milestone.observation_what_it_means),
               :theory => current_child.replace_forms(qs.milestone.research_background),
               :references => current_child.replace_forms(qs.milestone.research_references),
               :selected => true
              }
              respond_to do |format|
                format.html { render :partial => "watch_single", :locals => { :item => item, :time => time} }
              end
  end


  def edit
    @child = Child.find(params[:id])
    render :layout => "child"
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
      render :edit, :layout => "child"
    end   
  end
 
end
