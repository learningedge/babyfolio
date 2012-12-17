class QuestionsController < ApplicationController
  before_filter :require_child

  def initial_questionnaire    
    @behaviours = Behaviour.get_by_age(current_child.months_old).group_by{|b| b.category}    
    @behaviours.each do |k,v|
      @behaviours[k] = [v.first, current_child.behaviours.exists?("behaviours.category" => v.first.category)]
    end
#<<<<<<< HEAD
#    @questions = @questions.sort_by{|k,v| Question::CATS_ORDER.index(k)  }
#=======
    @q_age = @behaviours.first[1][0].age_from    
    session[:reflect_popup] = true
#>>>>>>> reworking db scheme , watch still to be done - gitt
  end

  def update_seen
    behaviour = Behaviour.find_by_id(params[:behaviour])
    @q_age = params[:start_age].to_i
    
    if params[:value].to_i == 1
      SeenBehaviour.find_or_create_by_child_id_and_behaviour_id(current_child.id, behaviour.id, :user => current_user)
      unless @q_age > behaviour.age_from
        next_behaviour = Behaviour.find_by_category(behaviour.category, :conditions => ['age_from > ?', behaviour.age_from], :order => 'age_from ASC', :limit => 1)
      end      
    else
#<<<<<<< HEAD
#      unless @q_age < question.age
#        next_question = Question.find_by_category(question.category, :conditions => ['age < ?', question.age], :order => 'age DESC', :limit => 1)
#=======
      unless @q_age < behaviour.age_from
        next_behaviour = Behaviour.find_by_category(behaviour.category, :conditions => ['age_from < ?', behaviour.age_from], :order => 'age_from DESC', :limit => 1)
#>>>>>>> reworking db scheme , watch still to be done - gitt
      end      
    end
    
    gray_out = true unless next_behaviour
    next_behaviour ||= behaviour
           
    respond_to do |format|
        format.html { render :partial => 'single_question', :locals => { :behaviour => next_behaviour, :category => behaviour.category, :completed => gray_out } }
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

#<<<<<<< HEAD
#
#  def initial_questionnaire_completed
#    @qs_ms = current_child.max_seen_by_category
#    @qs_ms.each do |q|
#      if q.milestone
#        te = TimelineEntry.build_entry("watch",
#                                     "is #{q.milestone.get_title}",
#                                     current_child,
#                                     current_user,
#                                     "Please describe a recent time when #{current_child.first_name} #{q.milestone.get_title}",   #Please describe a recent time when BABYNAME WTitlePast
#                                     q.category,
#                                     nil,
#                                     current_user.id,
#                                     q.milestone.mid
#                                   )
#        te.is_auto = true
#        te.save
#      end
#    end
#
#    current_user.user_actions.find_or_create_by_title('initial_questionnaire_completed')
#
#    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.first
#    #=========== temporary solution in case milestone for question is NIL =========
#    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.second unless qs.milestone
#    qs = @qs_ms.sort_by{|q| Question::CATS_ORDER.index(q.category)}.third unless qs.milestone
#    #=========== temporary solution in case milestone for question is NIL ====
#    if qs
#      unless current_user.user_emails.find_by_title('initial_questionnaire_completed')
#        UserMailer.registration_completed(current_user, current_child, qs).deliver if current_user.user_option.subscribed
#        current_user.user_emails.create(:title => 'initial_questionnaire_completed')
#      end
#=======
  def initial_questionnaire_completed
    @behaviours = current_child.max_seen_by_category
    @behaviours.each do |b|
      te = TimelineEntry.build_entry("watch",
                                      current_child.replace_forms(b.title_past),
                                      current_child,
                                      current_user,
                                      nil,
                                      b.category,
                                      nil,
                                      current_user.id,
                                      b
                                    )
      te.is_auto = true
      te.save
#>>>>>>> reworking db scheme , watch still to be done - gitt
    end

    if params[:add_child].present?
      redirect_to registration_new_child_path
    else
      redirect_to child_reflect_children_path
    end
  end

end
