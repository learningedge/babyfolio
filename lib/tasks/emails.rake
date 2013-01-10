namespace :emails do
  desc "Send emails to users that created account but haven't added a child within 30 minutes after account creation"
  task :send_step_2_pending => :environment do
    users = User.subscribed.with_actions('account_created', 'child_added')
    users.each do |u|
      joined_at = UserAction.find_by_user_id_and_title(u.id, 'account_created').created_at
      if (DateTime.now - joined_at.to_datetime).to_f * 24 * 60 >= 30
        UserMailer.step_2_pending(u).deliver
        ue = UserEmail.find_or_initialize_by_user_id_and_title(u.id, 'account_created' )
        ue.update_attributes(:updated_at => DateTime.now)                
      end
    end
  end

  desc "Send emails to users that added a child but haven't completed initiali questionnaire withing 30 minutes"
  task :send_step_3_pending => :environment do
    users = User.subscribed.with_actions('child_added', 'initial_questionnaire_completed')
    users.each do |u|
      child_created_at = UserAction.find_by_user_id_and_title(u.id, 'child_added').created_at
      if (DateTime.now - child_created_at.to_datetime).to_f * 24 * 60 >= 30
        c = u.children.first
        q = Question.includes(:milestone).find_by_category('l', :conditions => ["questions.age <= ? ", c.months_old], :order => 'questions.age DESC')
        m = q.milestone if q
        UserMailer.step_3_pending(u, c, m).deliver if m
        ue = UserEmail.find_or_initialize_by_user_id_and_title(u.id, 'child_added' )
        ue.update_attributes(:updated_at => DateTime.now)
      end
    end
  end

  desc "Send emails to users that have completed initial questionnaire"
  task :resend_registration_completed => :environment do
    users = User.subscribed.with_email('initial_questionnaire_completed', 1).where(["users.last_login_at < DATE(?)", DateTime.now - 7.days])
    users.each do |u|      
        c = u.children.first
        m = c.answers.includes([:question => :milestone]).where(["questions.category = ?", 'l']).order('questions.age DESC').limit(1).first.question.milestone
        if m
            UserMailer.registration_completed(u, c, m).deliver
            ue = u.user_emails.find_by_user_id_and_title(u.id, 'initial_questionnaire_completed')
            ue.update_attributes(:updated_at => DateTime.now)    
        end
    end
  end
end