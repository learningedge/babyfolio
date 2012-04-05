require 'roo'
class Question < ActiveRecord::Base

  scope :category_ages, lambda { |age, cat| select('distinct age').where(['age >= ? and category= ?', age, cat]).order('age ASC').limit(3) }
  scope :question_categories, select('distinct category') 
  scope :for_age_and_category, lambda { |months, cat| where(["age in (?) AND category =?", (category_ages(months, cat).map{|q| q.age}), cat])}
  
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

  def self.get_questions_for_age age   
    hash = Hash.new
    get_all_categories.each do |category|
      hash[category] = for_age_and_category(age, category).all
    end
    new_array = Array.new
    CATEGORIES.each do |c|
      if hash[c]
        new_array << { :category => c, :questions => hash[c]}
      end
    end
    new_array
  end

  def self.update_from_file(file_path)
    file = Excel.new(file_path)
    file.default_sheet = file.sheets.at(1)
    @array = Array.new
    2.upto(file.last_row) do |line|
      cat = file.cell(line,'C')
      desc  = file.cell(line,'F')
      age = file.cell(line,'J')
      @array << Question.create(:text => desc, :category => cat, :age => age)      
    end
    return @array
  end
end
