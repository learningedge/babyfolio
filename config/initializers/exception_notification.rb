if Rails.env == 'development'
  Babyfolio::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Babyfolio Exception] ",
  :sender_address => %{"Babyfolio" <info@babyfol.io>},
  :exception_recipients => %w{lukasz@codephonic.com}
end
