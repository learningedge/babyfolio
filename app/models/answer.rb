class Answer < ActiveRecord::Base
  belongs_to :child
  has_one :question
end
