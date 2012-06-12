class QuestionsController < ApplicationController
  before_filter :require_my_family
  before_filter :require_family_with_child
  skip_before_filter :clear_family_registration

  def index
    flash[:no_alert] = true  # DONT MARK QUESTIONS AS BEING REQUIRED TO ANSWER AT THE FIRST QUESTIONAIRE DISPLAY
    @current_step = 1
    @child = current_user.own_children.find(params[:child])
    @level = params[:level]

#    render :text => @answers.inspect
    if params[:level] == 'basic'
      @categories_with_questions = Question.get_questions_for_age(@child.months_old, '<', 1, 'DESC')
    elsif params[:level] == 'advanced'
      @categories_with_questions = Question.get_questions_for_age_range(@child.months_old, 2 , 1 )
    else
      @categories_with_questions = Question.get_questions_for_age(@child.months_old)
    end

    ages = @categories_with_questions.map{ |cq| cq[:questions].map{|q| q.age} }.flatten.uniq
    @answers = Hash.new
    Score.includes(:answers).where({:age => ages, :child_id => @child.id}).map{|sc| sc.answers}.flatten.each do |a|
      @answers[a.question_id.to_s] = a.value
    end

    @all_images = @child.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
    Log.create_log(current_user.id, ["Questionnaire(#{params[:level] || 'normal' }) requested for #{ @child.first_name }[#{@child.months_old}]."])
  end


#  FORM SUBMIT ACTION - LEVEL: NORMAL
  def complete_questionnaire    
    scores = []
    answers_log = []
    questions_array = []
    child_id = params[:child].to_i
    @level = params[:level]    
    @current_step = params[:current_step].to_i
    @categories_with_questions = []
    flash[:no_alert] = nil
    
   
#     IF ANY QUESTIONS ANSWERED
    if params[:question_answers] 

#      IF ALL QUESTIONS ANSWERED 
      if params[:question_answers].length == params[:question_ids].length
        answers = params[:question_answers]
        questions_ids = answers.map{ |k,v| k}
        questions = Question.find questions_ids
        questions_by_age = questions.group_by{|q| [q.age, q.category]}

        answers_log << "Questionnaire(#{ @level || 'normal' } - step #{ @current_step }) answers submitted."
        questions_by_age.each do |key, questions|
          answers_log << "Category: #{key[1]} [#{key[0]}]"
          answers_log << "<br/>"
          score = Score.find_or_create_by_child_id_and_age_and_category(child_id, key[0], key[1])          
          questions.each do |q|
            ans = Answer.find_or_initialize_by_score_id_and_question_id(score.id, q.id)
            ans.value = answers[q.id.to_s]
            ans.save
            answers_log << "#{ q.text }: <br/> #{ Question::ANSWERS[ans.value][:val] } <br/>"
          end
          score.update_value
          scores << score
        end
        Log.create_log(current_user.id, answers_log)


        if @level == 'basic'
          #        CHECK SCORE BETWEEN 0.0 AND 3.0 AND DISPLAY LEVEL ABOVE/BELOW FOR EACH OF THOSE STAGES
          unless scores.any?{|s| s.answers.any?{ |a| a.value == 'emerging' || a.value == 'frequent'}  }
            categories = scores.select{ |s| s.value >= 3.0 }
            questions_array = Array.new
            unless categories.empty?
              categories.each do |c|
                questions_array += Question.for_age_and_category(c.age , c.category, '>', 1, 'ASC')
              end
            end
            categories = scores.select{ |s| s.value >= 0.0 && s.value < 3.0 }
            unless categories.empty?
              categories.each do |c|
                questions_array += Question.for_age_and_category(c.age, c.category, '<', 1, 'DESC')
              end
            end                        
          end

        elsif @level == 'advanced'
          #        CHECK ALL ALWAYS_OR_BEYOND ANSWERS FOR EACH SCORE AND DISPLANY LEVEL ABOVE FOR EACH OF THOSE STAGES
          if  @current_step == 1
            questions_array = Array.new
            scores_by_category = scores.group_by{ |sc| sc.category }.map{ |k,v| {:category => k, :scores => v } }
            scores_by_category.each do |sc|
              max_score = sc[:scores].max_by(&:age)
              min_score = sc[:scores].min_by(&:age)
              if min_score.value <= 0.0
                questions_array += Question.for_age_and_category(min_score.age, min_score.category, '<', 1, 'DESC')
              elsif max_score.value >= 1.0
                questions_array += Question.for_age_and_category(max_score.age, max_score.category, '>', 1, 'ASC')
              end
            end        
          end

          
        else
          #        SELECT MAX SCORED CATEGORY AND LOAD 2 MORE LEVELS AFTER INITIAL FORM IS SUBMITTED
          if @current_step == 1
            max_score = scores.map{|sc| sc.value}.max
            min_score = scores.map{|sc| sc.value}.min
            categories = scores.select{ |s| s.value == max_score }
            questions_array = Array.new
            if categories
              categories.each do |c|
                questions_array += Question.for_age_and_category(c.age , c.category,'>', 2, 'ASC')
              end
            end
            categories = scores.select{ |s| s.value == min_score }
            if categories
              categories.each do |c|
                questions_array += Question.for_age_and_category(c.age , c.category,'<', 2, 'DESC')
              end
            end            
          end
          
        end

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
      @child = current_user.own_children.find(child_id)

      # GET ALREADY SUBMITTED ANSWERS FOR THE QUESTIONS
      if @answers.blank?
        ages = @categories_with_questions.map{ |cq| cq[:questions].map{|q| q.age} }.flatten.uniq
        @answers = Hash.new
        Score.includes(:answers).where({:age => ages, :child_id => @child.id}).map{|sc| sc.answers}.flatten.each do |a|
          @answers[a.question_id.to_s] = a.value
        end
      end
      @all_images = @child.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
      render :index
    else
      redirect_uri = child_profile_children_url
      if current_user.is_temporary
        redirect_uri = new_account_url
      else
        if family_registration?
          children = current_user.own_children
          next_child_idx = children.index { |ch| ch.id == child_id } + 1
          next_child = children[next_child_idx]
          if next_child
            redirect_uri = questions_url(:child => next_child.id, :level => @level)
          end
        end        
      end
      redirect_to redirect_uri
    end
  end




end
