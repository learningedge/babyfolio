class QuestionsController < ApplicationController
  before_filter :require_my_family
  before_filter :require_family_with_child

  def index
    flash[:no_alert] = true  # DONT MARK QUESTIONS AS BEING REQUIRED TO ANSWER AT THE FIRST QUESTIONAIRE DISPLAY
    @is_initial = true
    @child = current_user.own_children.includes(:answers).find(params[:child])
    @answers = Hash.new
    @child.answers.each do |a|
      @answers[a.question_id.to_s] = a.value
    end


#    render :text => @answers.inspect
    if params[:level] == 'basic'
      @form_link = complete_questionnaire_basic_url
      @categories_with_questions = Question.get_questions_for_age(@child.months_old, '<', 1, 'DESC')
    elsif params[:level] == 'advanced'
      @form_link = complete_questionnaire_advanced_url
      @categories_with_questions = Question.get_questions_for_age_range(@child.months_old, 2 , 1 )
    else
      @form_link = complete_questionnaire_url
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
    end

    @all_images = @child.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
  end

  def complete_questionnaire
    flash[:no_alert] = nil
    scores = []
    child_id = params[:child].to_i
    @categories_with_questions = []
   
#     IF ANY QUESTIONS ANSWERED
    if params[:question_answers] 

#      IF ALL QUESTIONS ANSWERED COUNT AND SAVE SCORES
      if params[:question_answers].length == params[:question_ids].length
        answers = params[:question_answers]
        questions_ids = answers.map{ |k,v| k}
        questions = Question.find questions_ids
        questions_by_age = questions.group_by{|q| [q.age, q.category]}

        questions_by_age.each do |key, questions|
          score = Score.find_or_create_by_child_id_and_age_and_category(child_id, key[0], key[1])
          questions.each do |q|
            ans = Answer.find_or_initialize_by_score_id_and_question_id(score.id, q.id)
            ans.value = answers[q.id.to_s]
            ans.save
          end
          score.update_value
          scores << score
        end        

#        SELECT MAX SCORED CATEGORY AND LOAD 2 MORE LEVELS AFTER INITIAL FORM IS SUBMITTED
        if params[:is_initial] == "true"
          max_score = scores.map{|sc| sc.value}.max
          categories = scores.select{ |s| s.value == max_score }
          if categories
            categories.each do |c|
              @categories_with_questions_single = Question.get_questions_for_age(c.age , '>', 2, 'ASC', c.category)
              @categories_with_questions += @categories_with_questions_single;
            end
            @is_initial = false
          end
        end
        flash[:notice] = "Questionnaire successfuly submitted."

      else  #   RELOAD QUESTIONS WITH ANSWERS IF ALL OF THE QUESTIONS HAVENT BEEN ANSWERED
        @answers = params[:question_answers]
        @is_initial = params[:is_initial]
        @categories_with_questions  = Question.order_categories(Question.find(params[:question_ids]).group_by{|q| q.category})
        flash[:notice] = "You need to answer all questions before proceeding."
      end

    else
      flash[:notice] = "Questionnaire terminated."
    end

#    IF THERE ARE ANY QUESTIONS TO DISPLAY COLLECT ALL NECESSARY INFORMATION AND DISPLAY INDEX VIEW
    if @categories_with_questions.length > 0
      @child = current_user.own_children.includes(:answers).find(child_id)
      if @answers.blank?
        @answers = Hash.new
          @child.answers.each do |a|
            @answers[a.question_id.to_s] = a.value
          end
      end
      @level = params[:level]
      @all_images = @child.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
      render :index
    else
      redirect_to child_profile_children_url
    end

  end

  def complete_questionnaire_basic
    scores = []
    child_id = params[:child].to_i
    @categories_with_questions = []

#     IF ANY QUESTIONS ANSWERED
    if params[:question_answers]

#      IF ALL QUESTIONS ANSWERED COUNT AND SAVE SCORES
      if params[:question_answers].length == params[:question_ids].length
        answers = params[:question_answers]
        questions_ids = answers.map{ |k,v| k}
        questions = Question.find questions_ids
        questions_by_age = questions.group_by{|q| [q.age, q.category]}

        questions_by_age.each do |key, questions|
          score = Score.find_or_create_by_child_id_and_age_and_category(child_id, key[0], key[1])
          questions.each do |q|
            ans = Answer.find_or_initialize_by_score_id_and_question_id(score.id, q.id)
            ans.value = answers[q.id.to_s]
            ans.save
          end
          score.update_value
          scores << score
        end

#        CHECK ALL ALWAYS_OR_BEYOND ANSWERS FOR EACH SCORE AND DISPLANY LEVEL ABOVE FOR EACH OF THOSE STAGES
        categories = scores.select{ |s| s.value >= 3.0 }
        unless categories.empty?
          categories.each do |c|
            @categories_with_questions_single = Question.get_questions_for_age(c.age , '>', 1, 'ASC', c.category)
            @categories_with_questions += @categories_with_questions_single;
          end
        end
        flash[:notice] = "Questionnaire successfuly submitted."

      else
        @answers = params[:question_answers]
        @categories_with_questions  = Question.find(params[:question_ids]).group_by{|q| q.category}.map{ | k,v | { :category => k, :questions => v} }
        flash[:notice] = "You need to answer all questions before proceeding."
      end

    else
      flash[:notice] = "Questionnaire terminated."
    end

    if @categories_with_questions.length > 0
      @child = current_user.own_children.includes(:answers).find(child_id)
      @level = params[:level]
      @all_images = @child.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
      render :index
    else
      redirect_to child_profile_children_url
    end

  end





end
