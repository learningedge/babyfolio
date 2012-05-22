class QuestionsController < ApplicationController
  before_filter :require_my_family
  before_filter :require_family_with_child

  def index
    @child = my_family.children.first
    @current_child = 0
    @next_child = 1 if my_family.children.size > 1
    @categories_with_questions = Question.get_questions_for_age(@child.months_old)
    @all_images = @child.moments.collect{ |mom| mom.media }.flatten    
  end

  def complete_questionnaire    
    child_id = my_family.children.at(params[:current_child].to_i).id
    if params[:question_answers] 

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
        end
        flash[:notice] = "Questionnaire for child has been successfuly submitted."
      else
        @answers = params[:question_answers]
        flash[:notice] = "You need to answer all questions before proceeding."
        params[:next_child] = params[:current_child].to_i
      end
    end
    

    if params[:next_child]
      params[:next_child] = params[:next_child].to_i
      @child = my_family.children.at(params[:next_child])
      @current_child = params[:next_child]
      @next_child = params[:next_child] + 1 if params[:next_child] < (my_family.children.length() -1)
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
      render :action => :index
    end

    if current_user.is_temporary
      redirect_to new_account_url
    end
        
  end
end
