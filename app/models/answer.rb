class Answer < ActiveRecord::Base
  belongs_to :score
  belongs_to :question

  def self.get_answers_for_questions(questions, child_id)
    ages = questions.map{ |cq| cq[:questions].map{|q| q.age} }.flatten.uniq
    answers = Hash.new
    Score.includes(:answers).where({:age => ages, :child_id => child_id}).map{|sc| sc.answers}.flatten.each do |a|
      answers[a.question_id.to_s] = a.value
    end
    answers
  end
end
