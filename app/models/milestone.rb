class Milestone < ActiveRecord::Base

  has_and_belongs_to_many :moment_tags
  has_many :questions

end
