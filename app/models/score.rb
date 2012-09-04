class Score < ActiveRecord::Base
  belongs_to :child
  has_many :answers
  has_many :questions, :through => :answers

  scope :select_ages, lambda {|age, dir, count, order| select('distinct age').where('age ' + dir + ' ?', age).limit(count).order("age #{order}") }
  
  before_save :update_validation_day

  def update_value_and_age_day
    val = 0.0
    a_count = 0.0   
    self.answers.each do |a|
      a_count += 1.0
      val += Question::ANSWERS[a.value][:score].to_f
    end
    self.value = val/a_count
    self.save
  end

  def self.update_scores(answers, child, user_id)
    answers_log = []
    scores = []
    questions_ids = answers.map{ |k,v| k}
    questions = Question.find questions_ids
    questions_by_age = questions.group_by{|q| [q.age, q.category]}

    answers_log << "Questionnaire(#{ @level || 'normal' } - step #{ @current_step }) answers submitted."
    questions_by_age.each do |key, questions|
      answers_log << "Category: #{key[1]} [#{key[0]}]"
      answers_log << "<br/>"
      score = Score.find_or_create_by_child_id_and_age_and_category(child.id, key[0], key[1])
      questions.each do |q|
        ans = Answer.find_or_initialize_by_score_id_and_question_id(score.id, q.id)
        ans.value = answers[q.id.to_s]
        ans.valid_from_age_day = child.days_old
        ans.save
        answers_log << "#{ q.text }: <br/> #{ Question::ANSWERS[ans.value][:val] } <br/>"
      end
      score.update_value_and_age_day
      scores << score
    end
    
    Log.create_log(user_id, answers_log)    
    scores
  end

  #================ NORMAL ==============

  def self.get_emerging_or_frequent_strength(scores)
    emerging = scores.find{ |s| s.answers.any?{ |a| a.value == "emerging" }}
    frequent = scores.find{ |s| s.answers.any?{ |a| a.value == "frequent" }}

    if emerging.present? && frequent.present?
      if frequent.age > emerging.age
        result = frequent.answers.find_by_value("frequent") if frequent    
      else 
        result =  emerging.answers.find_by_value("emerging") if emerging    
      end    
    else
      result = emerging.answers.find_by_value("emerging") if emerging    
      result = frequent.answers.find_by_value("frequent") if result.nil? && frequent  
    end
    return result
  end

  def self.get_emerging_or_frequent_weakness(scores)
    scores = scores.reverse
    emerging = scores.find{ |s| s.answers.any?{ |a| a.value == "emerging" }}
    frequent = scores.find{ |s| s.answers.any?{ |a| a.value == "frequent" }}
    
    if emerging.present? && frequent.present?
      if frequent.age < emerging.age
        result = frequent.answers.find_by_value("frequent") if frequent    
      else 
        result =  emerging.answers.find_by_value("emerging") if emerging    
      end    
    else
      result = emerging.answers.find_by_value("emerging") if emerging    
      result = frequent.answers.find_by_value("frequent") if result.nil? && frequent  
    end
    return result
  end

  # function that returns strength & weakness(2x LWs) for child for immediate use
  def self.normal_immediate_LWs(child)
    current_age = child.scores.select_ages(child.months_old, '<=', 1, 'DESC').map{ |s| s.age }

    above3_ages = child.scores.select_ages(current_age, '>', 3, 'ASC').map{ |s| s.age }    
    above3_scores = child.scores.includes(:answers).where(:age => above3_ages).order(:value).all
    current_scores = child.scores.includes(:answers).where(:age => current_age).order(:value).all

    scores = current_scores + above3_scores
    unless Score.any_score_outdated?(scores, child)

      str = self.get_emerging_or_frequent_strength(above3_scores.reverse)
      str = self.get_emerging_or_frequent_strength(current_scores.reverse) unless str
      
      min_val = current_scores.first.value
      lowest_scores = current_scores.select{ |cs| cs.value = min_val }
      lowest_cats = lowest_scores.map{ |s| s.category }

      lower_scores = []
      lowest_cats.each do |c|
        lower_scores = child.scores.includes("answers").where(["age < ? AND category=?", current_age, c]).order("age DESC").all(:limit => 2)
      end
      
      weak = self.get_emerging_or_frequent_weakness(lower_scores)
      unless weak
        lowest_cats.each do |c|
          lower_scores = child.scores.includes('answers').where(["age < ? AND category=?", current_age, c]).order("age DESC").all(:limit => 3)
        end
      end
      weak = self.get_emerging_or_frequent_weakness(lower_scores)

      unless weak 
        current_scores.sort{|a,b| a.value <=> b.value }
        weak = self.get_emerging_or_frequent_weakness(current_scores)
      end
      return [str, weak]
    end
  end

  #================ NORMAL ==============


  #================ BASIC ==============

  # function that returns 1 x LW for child for immediate use
  def self.basic_immediate_LWs(child)
    current_age = child.scores.select_ages(child.months_old, '<=', 1, 'DESC').map{ |s| s.age }
    below1_age = child.scores.select_ages(current_age, '<', 1, 'DESC').map{ |s| s.age }    
    scores = child.scores.includes(:answers).where(:age => below1_age).all

    unless Score.any_score_outdated?(scores, child)
      first_freq_or_emer = scores.find{ |s| s.answers.any?{ |a| a.value == "frequent" || a.value == "emerging" }}
      
      while first_freq_or_emer.blank? && scores.present?
        new_scores = []
        scores_always, scores_not_yet  = scores.partition { |s| s.value == 3.0} 

        scores_always.each do |s|          
          new_scores += child.scores.includes('answers').where(["age > ? AND category = ?", s.age, s.category]).order("age ASC").all(:limit => 1)
        end

        scores_not_yet.each do |s|
          new_scores += child.scores.includes('answers').where(["age < ? AND category = ?", s.age, s.category]).order("age DESC").all(:limit => 1)
        end

        scores = new_scores
        first_freq_or_emer = scores.find{ |s| s.answers.any?{ |a| a.value == "frequent" || a.value == "emerging" }}
      end

      result = first_freq_or_emer.answers.find{ |a| a.value == "frequent" || a.value == "emerging"} if first_freq_or_emer
      return [result]
    end
  end

  #================ BASIC ==============


  #================ ADVANCED ==============
  
  def self.advanced_immediate_LWs(child)
    current_and_2below_ages = child.scores.select_ages(child.months_old, '<=', 3, 'DESC').map{ |s| s.age }
    above_ages = child.scores.select_ages(child.advanced, '>', 1, 'ASC').map{ |s| s.age }
    ages = []
    ages = current_and_2below_ages + above_ages
    scores = child.scores.includes(:answers).find_all_by_age(ages)    
     
    unless Score.any_score_outdated?(scores, child)

      scores_by_category = scores.group_by{ |s| s.category }
      scores_by_category.each do |k,v|
        max_score = v.max_by(&:age)
        min_score = v.min_by(&:age)

        if min_score.value <= 0.5
          scores += child.scores.includes(:answers).where(["age < ? AND category = ?", min_score.age, min_score.category ]).all(:limit => 1)
        elsif max_score.value >= 2.5
          scores += child.scores.includes(:answers).where(["age > ? AND category = ?", max_score.age, max_score.category ]).all(:limit => 1)
        end
      end
      
#      closest_score = scores.sort{ |a,b| a.value <=> b.value }.min_by{ |s| (1.5 - s.value).abs } if scores.present?
      closest_score = scores.sort{ |a,b| (1.5 - a.value).abs <=> (1.5 - b.value).abs }.first{|s| s.answers.any?{ |a| a.value == "emerging" || a.value == "frequent"}} if scores.present?
      answers = closest_score.answers.all{ |a| a.value == "frequent" || a.value == "emerging"} if closest_score.answers.present?
      return answers
    end
  end

  #================ ADVANCED ==============

  def self.select_LWs child
    l_bsc = { :lvl => 'basic', :val => (child.basic.blank? || child.basic > child.months_old) ? -1 : child.basic}
    l_nrml = { :lvl => 'normal', :val => (child.normal.blank? || child.normal > child.months_old) ? -1 : child.normal}
    l_adv = { :lvl => 'advanced', :val => (child.advanced.blank? || child.advanced > child.months_old) ? -1 : child.advanced}

    max = [l_adv, l_nrml, l_bsc].find{ |i| i[:val] == [l_adv[:val], l_nrml[:val], l_bsc[:val]].max }
    current_ages = Question.select_ages(child.months_old, '<=', 1, 'DESC').first
    max_ages = Question.select_ages(max[:val], '<=', 1, 'DESC').first if max[:val] >= 0    

    return nil  if max_ages.blank? || current_ages.age != max_ages.age 

    if max[:lvl] == 'basic'
      result = Score.basic_immediate_LWs child
    elsif max[:lvl] == 'normal'
      result = Score.normal_immediate_LWs child
    else
      result = Score.advanced_immediate_LWs child
    end

    mids = []
    if result.present?
      result.each do |a|
        mids << Question.select(:mid).find(a.question_id).mid if a
      end
    end
     
    return mids
  end

  def self.any_score_outdated? scores, child
    diff = 14 if child.days_old <= 365
    diff = 30 if child.days_old > 365
    scores.any? { |sc| sc.valid_from_age_day && (child.days_old - sc.valid_from_age_day) > diff }    
  end

  private 
     def update_validation_day
      min = self.answers.minimum(:valid_from_age_day)
      self.valid_from_age_day =  min if min
     end

end
