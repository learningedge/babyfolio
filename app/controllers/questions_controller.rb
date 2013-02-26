class QuestionsController < ApplicationController
  before_filter :require_child

  def initial_questionnaire    
    @step = 1    
    @age = current_child.months_old
    @q_age = Question.select_ages(@age, '<=', 1, 'DESC').first.age    
    @questions = Question.find_all_by_age(@q_age).group_by{|q| q.category}
    @questions.each do |k,v|
      @questions[k] = [v.first, current_child.questions.joins(:answers).exists?("answers.child_id" => current_child.id, "questions.category" => v.first.category, "answers.value" => "seen")]
    end
    @questions = @questions.sort_by{|k,v| Question::CATS_ORDER.index(k)  }
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
    a = Answer.find_or_initialize_by_child_id_and_question_id(current_child.id, ms.questions.first.id, :value => 'seen')
    if a.new_record?
      current_child.users.each do |relative|
        UserMailer.child_entered_learning_window(relative, current_child, ms).deliver unless relative.id == current_user.id
      end
      a.save
    end    
    respond_to do |format|
        format.html { render :text => 'success' }
    end
  end


  def initial_questionnaire_completed
    @qs_ms = current_child.max_seen_by_category    
    @qs_ms.each do |q|
      if q.milestone
        te = TimelineEntry.build_entry("watch",
                                     "is #{q.milestone.get_title}",
                                     current_child,
                                     current_user,
                                     "Please describe a recent time when #{current_child.first_name} #{q.milestone.get_title}",   #Please describe a recent time when BABYNAME WTitlePast
                                     q.category,
                                     nil,
                                     current_user.id,
                                     q.milestone.mid
                                   )
        te.is_auto = true
        te.save
      end
    end

    current_user.user_actions.find_or_create_by_title('initial_questionnaire_completed')

    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.first
    #=========== temporary solution in case milestone for question is NIL =========
    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.second unless qs.milestone
    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.third unless qs.milestone
    #=========== temporary solution in case milestone for question is NIL ====
    if qs
      unless current_user.user_emails.find_by_title('initial_questionnaire_completed')
        UserMailer.registration_completed(current_user, current_child, qs).deliver if current_user.user_option.subscribed
        current_user.user_emails.create(:title => 'initial_questionnaire_completed')
      end      
    end

    if params[:add_child].present?
      redirect_to registration_new_child_path
    else
      redirect_to child_reflect_children_path
    end
  end

end
