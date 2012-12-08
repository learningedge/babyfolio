ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'], 
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'yourapp.heroku.com',
  :authentication => :plain,
}
ActionMailer::Base.delivery_method = :smtp

#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :domain => "codephonic.com",
#  :user_name => "rafal@codephonic.com",
#  :password => "work@codephonic.com",
#  :authentication => "plain",
#  :enable_starttls_auto => true
#}
