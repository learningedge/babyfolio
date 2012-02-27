class Child < ActiveRecord::Base
  belongs_to :family

  validates :first_name, :presence => true
  validates :birth_date, :presence => true

  def formated_birth_date
    birth_date.strftime("%m/%d/%Y") unless birth_date.nil?
  end
end
