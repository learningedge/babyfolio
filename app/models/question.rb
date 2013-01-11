require 'roo'
class Question < ActiveRecord::Base
  
  has_many :answers
  belongs_to :milestone, :class_name =>"Milestone", :primary_key => 'mid', :foreign_key => 'mid'


  scope :select_ages, lambda {|age, dir, count, order| select('distinct age').where('age ' + dir + ' ?', age).limit(count).order("age #{order}") }

  scope :question_categories, select('distinct category') 
  scope :category_ages, lambda { |age, cat, dir, count, order| select('distinct age').where(['age ' + dir + ' ? and category= ?', age, cat]).order('age ' + order).limit(count) } 
  scope :for_age_and_category, lambda { |months, cat, dir, count, order| where(["age in (?) AND category =?", (category_ages(months, cat, dir, count, order).map{|q| q.age}), cat])}    

  ANSWERS = {
    'not_yet' => { :val => 'Not Yet', :order => 0, :score => 0},
    'emerging' => { :val => 'Emerging', :order => 1, :score => 1},
    'seen' => { :val => "I've seen it", :order => 2, :score => 1.5},
    'frequent' => { :val => 'Frequent', :order => 3, :score => 2},
    'always_or_beyond' => { :val => 'Always or Beyond', :order => 4, :score => 3},    
  }

  def self.answers_in_order
    ANSWERS.sort_by{|k,v| v[:order]}
  end  

  CATS = {
    "l" => "Language",
    "ln" => "Logic",
    "s" => "Social",
    "v" => "Visual",
#    "v" => "Visual & Spatial Reasoning",
    "mv" => "Movement",
#    "e" => "Emotional",
#    "m" => "Music"
  }

  CATS_ORDER = ["l","ln", "s","v","mv"]
  
  CATEGORIES = [
    "Emotional",
    "Social",
    "Reasoning",
    "Logic",
    "Language",
    "Physical"
  ]
  

  def self.get_all_categories
    @all_categories = question_categories.all.map{|q| q.category} if @all_categories.blank?
    return @all_categories
  end

  def self.order_categories hash
    new_array = Array.new
    CATS.map{|k,v| k}.each do |c|
      if hash[c]
        new_array << { :category => c, :questions => hash[c]}
      end
    end
    new_array
  end

  def self.get_questions_for_age age, dir = '<=', how_many = 1, order = 'DESC', categories = nil
    hash = Hash.new
    categories = get_all_categories unless categories
    categories.each do |category|        
        ages = category_ages(age, category, dir, how_many, order).map{|q| q.age}
        next if ages && age - ages.max > 6
        hash[category] = for_age_and_category(age, category, dir, how_many, order).all        
    end
    return order_categories(hash)
  end

  def self.get_questions_for_age_range age, below, above, categories = nil
    hash = Hash.new
    categories = get_all_categories unless categories
    categories.each do |category|
        ages = category_ages(age, category, '<=', below + 1, 'DESC').map{|q| q.age}
        next if ages && age - ages.max > 6
        hash[category] = for_age_and_category(age, category, '<=', below + 1, 'DESC').all
        hash[category] += for_age_and_category(age, category, '>', above, 'ASC').all
    end
    return order_categories(hash)
  end

  def self.get_questions_for_next_step(level, scores, current_step, child)
    questions_array = []
    if level == 'basic'
      questions_array += Question.next_step_basic(scores, child)
    elsif level == 'advanced'
      questions_array += Question.next_step_advanced(scores, current_step, child)
    else
      questions_array += Question.next_step_normal(scores, current_step, child)
    end
    questions_array
  end


  # BASIC QUESTIONNAIRE - question retrieval for subsequent step
  def self.next_step_basic(scores, child)
    questions_array = []

    unless scores.any?{|s| s.answers.any?{ |a| a.value == 'emerging' || a.value == 'frequent'}  }
      questions_array = Array.new
      categories = scores.select{ |s| s.value >= 3.0 }
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

    child.update_attribute(:basic, child.months_old) if questions_array.blank?
    questions_array
  end

  # ADVANCED QUESTIONNAIRE - question retrieval for subsequent step
  def self.next_step_advanced(scores, current_step, child)    
    questions_array = []
    if  current_step == 1
      questions_array = Array.new
      scores_by_category = scores.group_by{ |sc| sc.category }.map{ |k,v| {:category => k, :scores => v } }
      scores_by_category.each do |sc|
        max_score = sc[:scores].max_by(&:age)
        min_score = sc[:scores].min_by(&:age)
        if min_score.value <= 0.5
          questions_array += Question.for_age_and_category(min_score.age, min_score.category, '<', 1, 'DESC')
        elsif max_score.value >= 2.5
          questions_array += Question.for_age_and_category(max_score.age, max_score.category, '>', 1, 'ASC')
        end
      end
    end

    child.update_attribute(:advanced, child.months_old) if questions_array.blank?
    questions_array
  end

  # NORMAL QUESTIONNAIRE - question retrieval for subsequent step
  def self.next_step_normal(scores, current_step, child)
    questions_array = []
    if current_step == 1
      max_score = scores.map{|sc| sc.value}.max
      min_score = scores.map{|sc| sc.value}.min
      categories = scores.select{ |s| s.value == max_score }
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
    elsif current_step == 2

      below, above = scores.partition{|s| s.age < child.months_old }
      below.sort{|a,b| a.age <=> b.age}
      above = above.sort{|a,b| a.age <=> b.age}.reverse
      str = Score.get_emerging_or_frequent_strength(above)
      weak = Score.get_emerging_or_frequent_weakness(below)

      unless str
        sc_gr = above.group_by{|a| a.category}
        categories = sc_gr.map {|k,v| [k,v.map{|a| a.age }.max]}
        categories.each do |c|
          questions_array += Question.for_age_and_category(c[1] , c[0],'>', 1, 'ASC')
        end        
      end

      unless weak
        sc_gr = below.group_by{|a| a.category}
        categories = sc_gr.map {|k,v| [k,v.map{|a| a.age }.min]}
        categories.each do |c|
          questions_array += Question.for_age_and_category(c[1] , c[0],'<', 1, 'DESC')
        end        
      end            
    end

    child.update_attribute(:normal, child.months_old) if questions_array.blank?
    questions_array
  end

end
