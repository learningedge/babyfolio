class Child < ActiveRecord::Base
  belongs_to :family

  validates :first_name, :presence => true
  validates :birth_date, :presence => true
end
