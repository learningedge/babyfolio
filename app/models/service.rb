class Service < ActiveRecord::Base
  belongs_to :user


  scope :youtube, where(:provider => 'youtube')
end
