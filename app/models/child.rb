require "open-uri"

class Child < ActiveRecord::Base

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::DateHelper
 
  attr_accessor :profile_image

  has_many :relations
  has_many :users, :through => :relations, :conditions => "relations.accepted = 1"
  has_many :admins, :through => :relations, :conditions => ["relations.accepted = 1 AND relations.is_admin = ?", true], :source => :user

  has_one :attachment, :as => :object
  has_one :media, :through => :attachment  
  has_many :answers
  has_many :questions, :through => :answers
  has_many :timeline_entries, :class_name => "TimelineEntry"
  has_many :likes
  has_many :user_emails

  belongs_to :user_action

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
    /(#)+he\/she(#)+/ => ['he', 'she'],
    /(#)+He\/[S,s]he(#)+/ => ['He', 'She'],
    /(#)+his\/her(#)+/ => ['his', 'her'],
    /(#)+His\/Her(#)+/ => ['His', 'Her'],
    /(#)+him\/her(#)+/ => ['him', 'her'],
    /(#)+Him\/Her(#)+/ => ['Him', 'Her'],
    /(#)+his\/hers(#)+/ => ['his', 'hers'],
    /(#)+His\/Hers(#)+/ => ['His', 'Hers'],
    /(#)+himself\/herself(#)+/ => ['himself', 'herself'],
    /(#)+Himself\/Herself(#)+/ => ['Himself', 'Herself'],
    /(<)+His\/Her(>)+/ => ['His', 'Her'],
    /(<)+his\/her(>)+/ => ['his', 'her'],
    /(<)+Him\/Her(>)+/ => ['Him', 'Her'],
    /(<)+him\/her(>)+/ => ['him', 'her'],
    /(<)+He\/She(>)+/ => ['He', 'She'],
    /(<)+he\/she(>)+/ => ['he', 'she']
  }


  def max_seen_by_category
    questions = self.questions.where(["answers.value = 'seen'"]).group('questions.category').select('questions.category, max(questions.age) as age').order('age desc')    
    result = []
    questions.each do |q|
      result << self.questions.includes(:milestone).find_by_age_and_category(q.age, q.category)
    end
    result
  end

  def max_seen_for_category category
    question = self.questions.where(["answers.value = 'seen' AND questions.category =?", category]).select('questions.category, questions.age').order('age desc').limit(1).first
    result = self.questions.includes(:milestone).find_by_age_and_category(question.age, question.category)
    return result
  end

  def get_next_category_question_with_milestone user, current_category
    question = nil    
    current_category ||= Question::CATS_ORDER.first

    user.user_option.get_next_newsletter_categories(current_category).each do |category|
      answer = self.answers.includes([:question => :milestone]).where(["questions.category = ?", category]).order('questions.age DESC').limit(1).first
      question = answer.question unless answer.nil?
      break unless answer.nil?
    end

    return question
  end

  def get_first_answer_for_one_of_the_categories
    a = nil
    Question::CATS_ORDER.each do |category|
      a = self.answers.includes([:question => :milestone]).where(["questions.category = ?", category]).order('questions.age DESC').limit(1).first.question
      break unless a.nil?
    end

    return a
  end

  def user_is_admin? user
    relation = self.relations.find_by_user_id(user.id)
    return relation.is_admin if relation
  end

  def relation_to_current_user user
    rel = self.relations.find_by_user_id(user.id)
    rel.member_type if rel
  end

  def formated_birth_date
    birth_date.strftime("%m/%d/%Y") unless birth_date.nil?
  end

  def get_image_src size, default = "/images/img_upload_child.png"
    result = self.media.image.url(size) if self.media
    result = default if result.blank?
    result
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

  def replace_forms(question_text, truncate = 0)
      FORMS.each do |key, val|
        question_text = question_text.gsub(key, val[gender_index])
      end
      if truncate > 0
        question_text = truncate(question_text, :length => truncate, :separator => ' ')
      end
      question_text = question_text.gsub(/#first#|#Nickname#/, "<span class='bold'>#{self.first_name}</span>")
      return question_text.html_safe
  end

  def api_replace_forms(question_text, truncate = 0)
      FORMS.each do |key, val|
        question_text = question_text.gsub(key, val[gender_index])
      end
      if truncate > 0
        question_text = truncate(question_text, :length => truncate, :separator => ' ')
      end
      question_text = question_text.gsub(/#first#|#Nickname#/, "#{self.first_name}")
      return question_text.html_safe
  end


  def gender_index
    @index ||= (gender == 'male' ? 0 : 1);
  end

  def age_text
    distance_of_time_in_words_to_now(self.birth_date)
  end

  def joined    
      self.created_at.strftime("%-m/%-d/%y")
  end

end
