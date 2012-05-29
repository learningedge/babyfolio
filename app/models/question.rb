require 'roo'
class Question < ActiveRecord::Base

  has_many :answers

  scope :category_ages, lambda { |age, cat| select('distinct age').where(['age >= ? and category= ?', age, cat]).order('age ASC').limit(3) }

  scope :category_ages_below, lambda { |age, cat| select('distinct age').where(['age < ? and category= ?', age, cat]).order('age DESC').limit(1) }
  scope :category_ages_2_below, lambda { |age, cat| select('distinct age').where(['age < ? and category= ?', age, cat]).order('age DESC').limit(3) }
  scope :category_ages_above, lambda { |age, cat| select('distinct age').where(['age >= ? and category= ?', age, cat]).order('age ASC').limit(4) }
  
  scope :question_categories, select('distinct category') 
  scope :for_age_and_category, lambda { |months, cat| where(["age in (?) AND category =?", (category_ages(months, cat).map{|q| q.age}), cat])}
  scope :for_age_and_category_basic, lambda { |months, cat| where(["age in (?) AND category =?", (category_ages_below(months, cat).map{|q| q.age}), cat])}
  scope :for_age_and_category_advanced, lambda { |months, cat| where(["age in (?) AND category =?", (category_ages_2_below(months, cat).map{|q| q.age} + category_ages_above(months, cat).map{|q| q.age}), cat])}
  
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

  def self.get_questions_for_age age, level = nil
    hash = Hash.new
    get_all_categories.each do |category|
      if level == "advanced"
        hash[category] = for_age_and_category_advanced(age, category).all
      elsif level == "basic"
        hash[category] = for_age_and_category_basic(age, category).all
      else
        hash[category] = for_age_and_category(age, category).all
      end
    end
    new_array = Array.new
    CATEGORIES.each do |c|
      if hash[c]
        new_array << { :category => c, :questions => hash[c]}
      end
    end
    new_array
  end
  
end
