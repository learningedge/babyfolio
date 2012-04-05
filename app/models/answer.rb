class Answer < ActiveRecord::Base
  belongs_to :score
  has_one :question
end
