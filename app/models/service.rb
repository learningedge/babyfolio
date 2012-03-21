class Service < ActiveRecord::Base
  belongs_to :user

  scope :youtube, where(:provider => 'youtube')
  scope :flickr_service, where(:provider => 'flickr')

end
