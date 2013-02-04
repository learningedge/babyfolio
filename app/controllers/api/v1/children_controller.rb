class Api::V1::ChildrenController < ApplicationController
  respond_to :json
  before_filter :require_user

  def create
    @child = Child.new(params[:child])
    if @child.save
      rel = Relation.find_or_create_by_user_id_and_child_id(current_user.id, @child.id)
      rel.assign_attributes(:member_type => params[:relation_type], :accepted => 1, :token => current_user.perishable_token, :is_admin => true)
      rel.save
      current_user.reset_perishable_token!            
      set_current_child @child.id
      @status = true
    else
      @status = false
    end

    render :json => { success: @status }
  end

  def current
    @child = current_child
    render :json => @child
  end


##############
# PLAY
##############

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
                         :ms_title => current_child.api_replace_forms(ms[:milestone].title, 35),
                         :title => ms[:milestone].activity_1_title.present? ? current_child.api_replace_forms(ms[:milestone].activity_1_title, 60) : "Title goes here",
                         :setup => current_child.api_replace_forms(ms[:milestone].activity_1_set_up, 90),
                         :response => current_child.api_replace_forms(ms[:milestone].activity_1_response),
                         :variations => current_child.api_replace_forms(ms[:milestone].activity_1_modification),
                         :learning_benefits => current_child.api_replace_forms(ms[:milestone].activity_1_learning_benefits),
                         :selected => selected || false,
                         :likes => likes
                        }
    end
    @activities.first[:selected] = true unless @activities.any? { |a| a[:selected] == true }

    render :json => { activities: @activities }
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
      @time = "future"
    elsif age > qs.age
      @time = "past"
    else
      @time = "current"
    end

    ms_likes = qs.milestone.likes.find_by_child_id(current_child.id)
    likes = ms_likes.value unless ms_likes.nil?
    @item =  {
               :category => qs.category,
               :mid => qs.milestone.mid,               
               :ms_title => current_child.api_replace_forms(qs.milestone.title, 35),
               :title => qs.milestone.activity_1_title.blank? ? "Title goes here" : current_child.api_replace_forms(qs.milestone.activity_1_title, 60),
               :setup => current_child.api_replace_forms(qs.milestone.activity_1_set_up, 90),
               :response => current_child.api_replace_forms(qs.milestone.activity_1_response),
               :variations => current_child.api_replace_forms(qs.milestone.activity_1_modification),
               :learning_benefits => current_child.api_replace_forms(qs.milestone.activity_1_learning_benefits),
               :selected => true,
               :likes => likes
              }
    render :json => { activity: @item, time: @time }
  end


##############
# WATCH
##############
#
#  def watch
#    ms = []
#    @behaviours = []
#    current_questions = []
#
#    questions = current_child.max_seen_by_category
#
#    questions.each do |q|      
#      current_questions << Question.includes(:milestone).find_by_category(q.category, :conditions => ["questions.age > ?", q.age], :order => "questions.age ASC", :limit => 1)
#    end        
#
#    if params[:mid]
#      m = Milestone.includes(:questions).find_by_mid(params[:mid])
#    end
#
#    current_questions.each do |q|
#      if m.blank? || q.category != m.questions.first.category
#        ms  << {:category => q.category, :milestone => q.milestone, :time => "current" }
#      else
#        time = q.age > m.questions.first.age ? "past" : (q.age < m.questions.first.age ? "future" : "current")
#        ms  << { :category => m.questions.first.category, :milestone => m, :time => time }
#      end
#    end
#
#    ms.each do |m|
#        selected = true if m[:milestone].mid == params[:mid]
#        @behaviours << {
#                         :category => m[:category],
#                         :mid => m[:milestone].mid,
#                         :ms_title => current_child.api_replace_forms(m[:milestone].title, 35),
#                         :title => current_child.api_replace_forms(m[:milestone].get_title, 60),
#                         :subtitle =>  m[:milestone].observation_subtitle.blank? ? "Subtitle goes here" : current_child.api_replace_forms(m[:milestone].observation_subtitle),
#                         :desc => current_child.api_replace_forms(m[:milestone].observation_desc),
#                         :examples =>  current_child.api_replace_forms(m[:milestone].other_occurances),
#                         :activity_1_title => current_child.api_replace_forms(m[:milestone].activity_1_title, 40),
#                         :activity_2_title => current_child.api_replace_forms(m[:milestone].activity_2_title, 40),
#                         :activity_1_url => play_children_path(:mid => m[:milestone].mid, :no => 1),
#                         :activity_2_url => play_children_path(:mid => m[:milestone].mid, :no => 2),
#                         :why_important => current_child.api_replace_forms(m[:milestone].observation_what_it_means),
#                         :theory => current_child.api_replace_forms(m[:milestone].research_background),
#                         :references => current_child.api_replace_forms(m[:milestone].research_references),
#                         :time => m[:time],
#                         :selected => selected || false
#                        }
#    end
#    @behaviours.first[:selected] = true unless @behaviours.any? { |a| a[:selected] == true }
#
#    render :json => { behaviours: @behaviours }
#  end
#
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
      @time = "future"
    elsif qs_current.age > qs.age
      @time = "past"
    else
      @time = "current"
    end

    @item =  {
               :category => qs.category,
               :mid => qs.mid,
               :ms_title => current_child.api_replace_forms(qs.milestone.title, 35),
               :title =>  current_child.api_replace_forms(qs.milestone.get_title, 60),
               :subtitle =>  qs.milestone.observation_subtitle.blank? ? "Subtitle goes here" : current_child.api_replace_forms(qs.milestone.observation_subtitle),
               :desc => current_child.api_replace_forms(qs.milestone.observation_desc),
               :examples =>  current_child.api_replace_forms(qs.milestone.other_occurances),
               :activity_1_title => current_child.api_replace_forms(qs.milestone.activity_1_title, 40),
               :activity_2_title => current_child.api_replace_forms(qs.milestone.activity_2_title, 40),
               :activity_1_url => play_children_path(:mid => qs.mid, :no => 1),
               :activity_2_url => play_children_path(:mid => qs.mid, :no => 2),
               :why_important => current_child.api_replace_forms(qs.milestone.observation_what_it_means),
               :theory => current_child.api_replace_forms(qs.milestone.research_background),
               :references => current_child.api_replace_forms(qs.milestone.research_references),
               :selected => true
              }

    render :json => { behaviour: @item, time: @time }
  end



##############
# REFLECT
##############


  def reflect

    @reflections = []

    categorized_qs = current_child.max_seen_by_category.group_by{|q| q.category}
    categorized_qs.each do |k,v|
      categorized_qs[k] = v.first
      serialized = QuestionSerializer.new(v.first, scope: current_child, :root => false)
      @reflections << serialized
    end

    third_from_start = categorized_qs.values[2] 
    third_from_end = categorized_qs.values[-3]
    
    @str_answers = @reflections.reject{ |v| v.age <= third_from_start.age } unless third_from_start.nil?

    @weak_answers = @reflections.reject{ |v| v.age >= third_from_end.age } unless third_from_end.nil?
    @avg_answers = @reflections - @str_answers - @weak_answers

    render :json => {
      reflections: @reflections,
      strong: @str_answers,
      weak: @weak_answers,
      avg: @avg_answers
    }
  end



end

