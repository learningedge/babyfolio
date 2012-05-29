class Answer < ActiveRecord::Base
  belongs_to :score
  belongs_to :question
  
end
