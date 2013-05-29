class UserAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :child

  scope :not_newer_than, lambda { |date| where("DATE(user_actions.created_at) <= ?", date) } 
  scope :not_older_than, lambda { |date| where("DATE(user_actions.created_at) >= ?", date) }

  ACTIONS = {
    "WELCOME_PROGRAM_INITIAL_EMAIL" => 'welcome_program_initial_email_sent',
    "WELCOME_PROGRAM_DAY_1_EMAIL" => 'welcome_program_day_1_email_sent',
    "WELCOME_PROGRAM_DAY_2_EMAIL" => 'welcome_program_day_2_email_sent',    
    "WELCOME_PROGRAM_DAY_3_EMAIL" => 'welcome_program_day_3_email_sent',
    "WELCOME_PROGRAM_LANGUAGE_EMAIL" => 'welcome_program_language_email_sent',   
    "WELCOME_PROGRAM_LOGIC_EMAIL" => 'welcome_program_logic_email_sent',   
    "WELCOME_PROGRAM_SOCIAL_EMAIL" => 'welcome_program_social_email_sent',   
    "WELCOME_PROGRAM_VISUAL_EMAIL" => 'welcome_program_visual_email_sent',   
    "WELCOME_PROGRAM_MOVEMENT_EMAIL" => 'welcome_program_movement_email_sent',   
    "WELCOME_PROGRAM_EMOTIONAL_EMAIL" => 'welcome_program_emotional_email_sent'
  }

  def self.no_older_than date
    where(["user_actions.created_at >= ?", date])
  end
end
