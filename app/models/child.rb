require "open-uri"

class Child < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
 
  attr_accessor :profile_image

  belongs_to :family

#  has_attached_file :profile_image,
#    :styles => { :small => "40x40#", :medium => "93x93#", :large => "228x254#" },
#    :default_url => '/images/default_images/child_profile_:style.png'

  has_one :attachment, :as => :object
  has_one :media, :through => :attachment
  has_many :moments
  has_many :scores
  has_many :answers, :through => :scores
  has_many :questions, :through => :answers

#accepts_nested_attributes_for :attachment, :allow_destroy => true
# accepts_nested_attributes_for :media, :allow_destroy => true

  validates :first_name, :presence => true
  validates :birth_date, :presence => true

  GENDERS = {
    'Male' => 'male',
    'Female' => 'female'
  }

  FORMS = {
    /(#)+he\/she#/ => ['he', 'she'],
    /(#)+He\/She(#)+/ => ['He', 'She'],
    /(#)+his\/her(#)+/ => ['his', 'her'],
    /(#)+His\/Her(#)+/ => ['His', 'Her'],
    /(#)+him\/her(#)+/ => ['him', 'her'],
    /(#)+Him\/Her(#)+/ => ['Him', 'Her'],
    /(#)+his\/hers(#)+/ => ['his', 'hers'],
    /(#)+His\/Hers(#)+/ => ['His', 'Hers'],
    /(#)+himself\/herself(#)+/ => ['himself', 'herself'],
    /(#)+Himself\/Herself(#)+/ => ['Himself', 'Herself']
  }


  def formated_birth_date
    birth_date.strftime("%m/%d/%Y") unless birth_date.nil?
  end

  def media_ids_fom_moments
    
  end

  def months_old
    mnths = 0;
    while (self.birth_date + mnths.months) < Date.today do
      mnths += 1
    end
    return mnths > 0 ? mnths-1 : 0
  end

  def replace_question_forms(question_text)
      FORMS.each do |key, val|
        question_text = question_text.gsub(key, val[gender_index])
      end
      return question_text
  end

  def gender_index
    @index ||= (gender == 'male' ? 0 : 1);
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

end
