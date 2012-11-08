require "open-uri"

class Child < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::DateHelper
 
  attr_accessor :profile_image

  has_many :relations
  has_many :users, :through => :relations

  has_one :attachment, :as => :object
  has_one :media, :through => :attachment
  has_many :moments, :conditions => ["moments.visibility NOT IN (?)",Moment::ARCHIVED]
  has_many :answers
  has_many :questions, :through => :answers

  validates :first_name, :presence => true
  validates :birth_date, :presence => true

  scope :ids, select(:id)

  GENDERS = {
    'Male' => 'male',
    'Female' => 'female'
  }
  DEFAULTS = {
    :first_name => "__first_name"
  }

  FORMS = {
    /(#)+he\/she#/ => ['he', 'she'],
    /(#)+He\/[S,s]he(#)+/ => ['He', 'She'],
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

  def days_old
    (DateTime.now.to_date - self.birth_date.to_date).to_i
  end


  def replace_forms(question_text)
      FORMS.each do |key, val|
        question_text = question_text.gsub(key, val[gender_index])
      end
      question_text = question_text.gsub(/#first#|#Nickname#/, "<span class='bold'>#{self.first_name}</span>")
      return question_text
  end

  def gender_index
    @index ||= (gender == 'male' ? 0 : 1);
  end

  def get_all_images 
    self.moments.collect{ |mom| mom.media }.flatten.select{ |x| x.kind_of? MediaImage }.uniq
  end

  def age_text
    distance_of_time_in_words_to_now(self.birth_date)

#    distance_in_days = (Date.today - self.birth_date.to_date).to_i
#    case distance_in_days
#    when 1..31
#      if (self.birth_date + 1.month) < Date.today
#        return "#{distance_in_days} Days old"
#      else
#        return "1 Month old"
#      end
#    when 31..365
#      i = 1
#      while (self.birth_date + i.months) < Date.today do
#        i += 1
#      end
#      return  "#{pluralize(i, 'Month')} old"
#    else
#      return "something"
#    end
  end

end
