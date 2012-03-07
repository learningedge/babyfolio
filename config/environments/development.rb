Babyfolio::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  Rails.application.config.middleware.use OmniAuth::Builder do

    # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
    #   require 'openid/store/filesystem'

    # providers with id/secret, you need to sign up for their services (see below) and enter the parameters here
    provider :facebook, '263019473774028', '7c92fcaf00c30a9da772af2de7a2b144',{ :scope => 'email,offline_access,read_stream,user_photos', :display => 'popup' }
    provider :youtube, '821905120152.apps.googleusercontent.com', 'q9XDXCtGECoa0clbFMeVGuKT'

#    on_failure do |env|
#      message_key = 'jakistammessage'

#      new_path = "#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure?message=#{message_key}"
#      [302, {'Location' => new_path, 'Content-Type' => 'text/html', []]
#    end
  end

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  Paperclip.options[:command_path] = "/usr/bin/"
end
