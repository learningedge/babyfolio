class QuestionsController < ApplicationController
  before_filter :require_my_family
  before_filter :require_family_with_child

  def index
    if params[:next_child]
      params[:next_child] = params[:next_child].to_i
      @child = my_family.children.at(params[:next_child])
      @current_child = params[:next_child]
      @next_child = params[:next_child] + 1 if params[:next_child] < (my_family.children.length() -1)
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
      render :action => :index
    else
      @child = my_family.children.first
      @current_child = 0
      @next_child = 1 if my_family.children.size > 1
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
    end
  end

  def complete_questionnaire
    child_id = my_family.children.at(params[:current_child].to_i).id
    if params[:question_answers]
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
      flash[:notice] = "Questionnaire for child has been submitted without any answered questions."
    end
    if params[:next_child]
      redirect_to :action => :index, :next_child => params[:next_child]
    end
    
  end  
end
