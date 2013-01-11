namespace :emails do
  desc "Send emails to users that created account but haven't added a child within 30 minutes after account creation"
  task :send_step_2_pending => :environment do
    User.send_step_2_pending_emails
  end

  desc "Send emails to users that added a child but haven't completed initiali questionnaire withing 30 minutes"
  task :send_step_3_pending => :environment do
    User.send_step_3_pending_emails
  end

  desc "Send emails to users that have completed initial questionnaire"
  task :resend_registration_completed => :environment do
    User.resend_registration_completed
  end
end