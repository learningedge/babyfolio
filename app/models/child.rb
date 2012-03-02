require "open-uri"

class Child < ActiveRecord::Base

  include ActionView::Helpers::TextHelper

  belongs_to :family

  before_save :download_remote_image

  has_attached_file :profile_image, 
    :styles => { :small => "40x40#", :medium => "93x93#", :large => "228x254#" },
    :default_url => '/images/default_images/child_profile_:style.png'

  validates :first_name, :presence => true
  validates :birth_date, :presence => true


  def formated_birth_date
    birth_date.strftime("%m/%d/%Y") unless birth_date.nil?
  end

  def age_text
    distance_in_days = (Date.today - self.birth_date.to_date).to_i
    case distance_in_days
    when 1..31
      if (self.birth_date + 1.month) < Date.today
        return "#{distance_in_days} Days old"
      else
        return "1 Month old"
      end
    when 31..365
      i = 1
      while (self.birth_date + i.months) < Date.today do
        i += 1
      end
      return  "#{pluralize(i, 'Month')} old"
    else
      return "something"
    end
  end


private

  def download_remote_image
      self.profile_image = do_download_remote_image unless self.profile_image_remote_url.blank?
  end

  def do_download_remote_image
    io = open(URI.parse(self.profile_image_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
  end

end
