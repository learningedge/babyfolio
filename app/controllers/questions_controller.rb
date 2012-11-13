class QuestionsController < ApplicationController
  before_filter :before_filter_require
  skip_before_filter :clear_family_registration

  def before_filter_require
    if current_user
      require_child
    elsif !session[:temporary_user_id]
      redirect_to errors_permission_url
    end
  end

  def initial_questionnaire
    @step = 1    
    @age = current_child.months_old
    @q_age = Question.select_ages(@age, '<=', 1, 'DESC').first.age    
    @questions = Question.find_all_by_age(@q_age).group_by{|q| q.category}
    @questions.each do |k,v|
      @questions[k] = v.first
    end            
  end

  def update_seen
    question = Question.find(params[:question])
    Answer.find_or_create_by_child_id_and_question_id(params[:child_id], question.id, :value => 'seen')
    next_question = Question.find_by_category(question.category, :conditions => ['age > ?', question.age], :order => 'age ASC', :limit => 1)

    respond_to do |format|        
        format.html { render :partial => 'single_question', :locals => { :question => next_question, :category => question.category } }
    end              
  end

  def update_initial_questionnaire
    @step = params[:step].to_i
    @cat_ans = params[:categories_answered] || Array.new
    q_array = Array.new
    questions = Question.find_all_by_id(params[:questions])    

    
    questions.each do |q|
      if @step%2 == 1
          unless @cat_ans.include?(q.category)
            q_array += Question.find_all_by_category_and_age(q.category, q.age, :limit => 2)
          end
      else 
          q_age = Question.select_ages(q.age, '<', 1, 'DESC')
          if !@cat_ans.include?(q.category) && q_age.present?
            q_array += Question.find_all_by_category_and_age(q.category, q_age.first.age, :limit => 2)
          end          
      end
    end                                                          
       
    respond_to do |format|
        if q_array.empty? || questions.to_s == q_array.to_s
              format.js
              session[:reflect_popup] = true
        else
          @questions = q_array.group_by{|q| q.category}
          @questions.each do |k,v|
              if @step == 1 || (@step >= 2 && @step%2 == 0)
                @questions[k] = v.last
              else
                @questions[k] = v.first
              end
          end

          format.html { render :partial => 'questions_listing', :locals => { :questions => @questions, :step => @step + 1, :categories_answered => @cat_ans} }
        end
    end
  end

  def initial_questionnaire_completed    
    if params[:notice]
      flash[:notice] = params[:notice]
    else
      flash[:notice] = "Successfuly completed initial questionnaire!"
    end
    
    
    redirect_to child_reflect_children_path
  end

  def index
    if session[:temporary_user_created] 
      temporary_user_id = current_user.id
      clear_session
      session[:temporary_user_id] = temporary_user_id
    end

    flash[:no_alert] = true  # DONT MARK QUESTIONS AS BEING REQUIRED TO ANSWER AT THE FIRST QUESTIONAIRE DISPLAY
    @current_step = 1
    current_user ? user = current_user : user = User.find(session[:temporary_user_id])    
    @child = user.children.find(params[:child])
    @level = params[:level]

#    render :text => @answers.inspect
    if params[:level] == 'basic'
      @categories_with_questions = Question.get_questions_for_age(@child.months_old, '<', 1, 'DESC')
    elsif params[:level] == 'advanced'
      @categories_with_questions = Question.get_questions_for_age_range(@child.months_old, 2 , 1 )
    else
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
    end

    @answers = Answer.get_answers_for_questions(@categories_with_questions, @child.id)
    @all_images = @child.get_all_images
    Log.create_log(user.id, ["Questionnaire(#{params[:level] || 'normal' }) requested for #{ @child.first_name }[#{@child.months_old}]."])
    
    if @categories_with_questions.map {|el| el[:questions]}.flatten.empty?
      @no_questions =  "Sorry, there aren't any questions for your child's age."
    end    
  end


#  FORM SUBMIT ACTION
  def complete_questionnaire    
    scores = []
    questions_array = []
    current_user ? user = current_user : user = User.find(session[:temporary_user_id])
    child_id = params[:child].to_i
    @child = user.children.find(child_id)
    @level = params[:level]    
    @current_step = params[:current_step].to_i
    @categories_with_questions = []
    flash[:no_alert] = nil
   
#     IF ANY QUESTIONS ANSWERED
    if params[:question_answers] 

#      IF ALL QUESTIONS ANSWERED 
      if params[:question_answers].length == params[:question_ids].length

        scores += Score.update_scores(params[:question_answers], @child, user.id)
        questions_array += Question.get_questions_for_next_step(@level, scores, @current_step, @child)

        @current_step += 1
        flash[:no_alert] = true
        flash[:notice] = "Questionnaire submitted."
        
      else  #   RELOAD QUESTIONNAIRE IF SOME QUESTIONS HAVEN'T BEEN ANSWERED
        @answers = params[:question_answers]        
        questions_array  = Question.find(params[:question_ids])
        flash[:notice] = "You need to answer all questions before proceeding."
      end
    else
      flash[:notice] = "Questionnaire terminated."      
    end

#    IF THERE ARE ANY QUESTIONS TO DISPLAY COLLECT ALL NECESSARY INFORMATION AND DISPLAY INDEX VIEW
    if questions_array.length > 0
      @categories_with_questions  = Question.order_categories(questions_array.group_by{|q| q.category})


      # GET ALREADY SUBMITTED ANSWERS FOR THE QUESTIONS
      if @answers.blank?
        @answers = Answer.get_answers_for_questions(@categories_with_questions, @child.id)
      end
      @all_images = @child.get_all_images
      render :index
    else
      redirect_uri = child_profile_children_url
      if (!current_user and session[:temporary_user_id])
        redirect_uri = new_account_url
      else
        if family_registration?
          children = current_user.own_children
          next_child_idx = children.index { |ch| ch.id == @child.id } + 1
          next_child = children[next_child_idx]
          if next_child
            redirect_uri = questions_url(:child => next_child.id, :level => @level)
          end
        end        
      end

      if @level == 'basic'
        session[:level] = { child_id => 'basic' }
      elsif @level == 'advanced'
        session[:level] = { child_id => 'advanced' }
      else
        session[:level] = { child_id => 'normal' }
      end
      redirect_to redirect_uri
    end

  end




end
