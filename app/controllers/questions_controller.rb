class QuestionsController < ApplicationController
  before_filter :require_my_family
  before_filter :require_family_with_child

  def index
    @child = my_family.children.first
    @current_child = 0
    @next_child = 1 if my_family.children.size > 1
    @categories_with_questions = Question.get_questions_for_age(@child.months_old)
  end

  def complete_questionnaire
    child_id = my_family.children.at(params[:current_child].to_i).id
    answers = params[:question_answers]    
    
    unless answers.blank?
      params[:question_ids].each do |qid|
        if answers[qid]
          answer = Answer.find_or_create_by_child_id_and_question_id(child_id, qid)
          answer.update_attribute(:answer, answers[qid])
        end
      end
    end
    
    if params[:next_child]
      flash[:notice] = "Questionnaire for child has been successfuly submitted."
      params[:next_child] = params[:next_child].to_i
      @child = my_family.children.at(params[:next_child])
      @current_child = params[:next_child]
      @next_child = params[:next_child] + 1 if params[:next_child] < (my_family.children.length() -1)
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
      render :action => :index
    end    
  end
  
end
