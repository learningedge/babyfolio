class Api::V1::QuestionsController < ApplicationController
  layout false

  def initial_questionnaire    
    cookies[:current_category] ||= Question::CATS_ORDER.first

    @category = cookies[:current_category]

    @q_age = question_age
    @question = current_question_for @category

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
            
    end
    
    next_question ||= question
    @question = next_question

    respond_to do |format|
      format.js     
    end

  end

  def not_seen
    cats = Question::CATS_ORDER
    old_index = cats.index(cookies[:current_category])
    if ((old_index + 1) < cats.count)
      cookies[:current_category] = cats[old_index + 1]
      next_category = true
    else
      #we have run through all categories
    end
    redirect_to api_v1_initial_questionnaire_path
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

    current_user.user_actions.find_or_create_by_title('initial_questionnaire_completed')

    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.first
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

private

  def question_age
    age = current_child.months_old
    q_age = Question.select_ages(age, '<=', 1, 'DESC').first.age    
    return q_age
  end
 
  def current_question_for(category)
    q_age = question_age
    questions = Question.find_all_by_age(q_age).select{ |q| q.category == category }
    unseen_qs = questions.map{|q| current_child.questions.include?(q) == false}
    return questions.first
  end

end


