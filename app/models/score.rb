class Score < ActiveRecord::Base
  belongs_to :child
  has_many :answers
  has_many :questions, :through => :answers


  def update_value
    val = 0.0
    a_count = 0.0
    self.answers.each do |a|
      a_count += 1.0
      val += Question::ANSWERS[a.value][:score].to_f
    end
    self.update_attribute(:value, val/a_count)
  end
end
