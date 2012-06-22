require 'roo'
class Question < ActiveRecord::Base

  has_many :answers
  belongs_to :milestone, :foreign_key => :mid

  scope :question_categories, select('distinct category') 
  scope :category_ages, lambda { |age, cat, dir, count, order| select('distinct age').where(['age ' + dir + ' ? and category= ?', age, cat]).order('age ' + order).limit(count) } 
  scope :for_age_and_category, lambda { |months, cat, dir, count, order| where(["age in (?) AND category =?", (category_ages(months, cat, dir, count, order).map{|q| q.age}), cat])}

  ANSWERS = {
    'not_yet' => { :val => 'Not Yet', :order => 0, :score => 0},
    'emerging' => { :val => 'Emerging', :order => 1, :score => 1},
    'frequent' => { :val => 'Frequent', :order => 2, :score => 2},
    'always_or_beyond' => { :val => 'Always or Beyond', :order => 3, :score => 3}
  }

  def self.answers_in_order
    ANSWERS.sort_by{|k,v| v[:order]}
  end  

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
    CATEGORIES.each do |c|
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

#  def self.get_questions_below_age age, how_many = 1 , categories = nil
#    hash = Hash.new
#    categories = get_all_categories unless categories
#    categories.each do |category|
#        hash[category] = for_age_and_category(age, category, '<', how_many).all
#    end
#    return order_categories(hash)
#  end
  
end
