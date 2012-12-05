class QuestionsController < ApplicationController
  before_filter :require_child
  skip_before_filter :clear_family_registration


  def initial_questionnaire
    @step = 1    
    @age = current_child.months_old
    @q_age = Question.select_ages(@age, '<=', 1, 'DESC').first.age    
    @questions = Question.find_all_by_age(@q_age).group_by{|q| q.category}
    @questions.each do |k,v|
      @questions[k] = [v.first, current_child.questions.joins(:answers).exists?("answers.child_id" => current_child.id, "questions.category" => v.first.category, "answers.value" => "seen")]
    end            
  end

  def update_seen
    question = Question.find_by_id(params[:question])
    @q_age = params[:start_age].to_i
    
    if params[:value].to_i == 1
      Answer.find_or_create_by_child_id_and_question_id(params[:child_id], question.id, :value => 'seen')
      unless @q_age > question.age        
        next_question = Question.find_by_category(question.category, :conditions => ['age > ?', question.age], :order => 'age ASC', :limit => 1)
      end      
    else
      unless @q_age < question.age        
        next_question = Question.find_by_category(question.category, :conditions => ['age < ?', question.age], :order => 'age DESC', :limit => 1)
      end      
    end
    
    gray_out = true unless next_question
    next_question ||= question
           
    respond_to do |format|
        format.html { render :partial => 'single_question', :locals => { :question => next_question, :category => question.category, :completed => gray_out } }
    end
  end

  def update_watched
    ms = Milestone.includes(:questions).find_by_mid(params[:mid])
    Answer.find_or_create_by_child_id_and_question_id(current_child.id, ms.questions.first.id, :value => 'seen')
    respond_to do |format|
        format.html { render :text => 'success' }
    end
  end

#  def update_initial_questionnaire
#    @step = params[:step].to_i
#    @cat_ans = params[:categories_answered] || Array.new
#    q_array = Array.new
#    questions = Question.find_all_by_id(params[:questions])
#
#
#    questions.each do |q|
#      if @step%2 == 1
#          unless @cat_ans.include?(q.category)
#            q_array += Question.find_all_by_category_and_age(q.category, q.age, :limit => 2)
#          end
#      else
#          q_age = Question.select_ages(q.age, '<', 1, 'DESC')
#          if !@cat_ans.include?(q.category) && q_age.present?
#            q_array += Question.find_all_by_category_and_age(q.category, q_age.first.age, :limit => 2)
#          end
#      end
#    end
#
#    respond_to do |format|
#        if q_array.empty? || questions.to_s == q_array.to_s
#              format.js
#              session[:reflect_popup] = true
#        else
#          @questions = q_array.group_by{|q| q.category}
#          @questions.each do |k,v|
#              if @step == 1 || (@step >= 2 && @step%2 == 0)
#                @questions[k] = v.last
#              else
#                @questions[k] = v.first
#              end
#          end
#
#          format.html { render :partial => 'questions_listing', :locals => { :questions => @questions, :step => @step + 1, :categories_answered => @cat_ans} }
#        end
#    end
#  end
#
  def initial_questionnaire_completed
    @qs_ms = current_child.max_seen_by_category
    @qs_ms.each do |q|
      TimelineEntry.create({ :entry_type => "reflect", :child_id => current_child.id, :title => q.milestone.title, :category => q.category, :user => current_user })
    end

    redirect_to child_reflect_children_path
  end

end
