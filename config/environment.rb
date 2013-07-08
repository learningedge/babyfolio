# Load the rails application
require File.expand_path('../application', __FILE__)
require "pp"

# Initialize the rails application
Babyfolio::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/      
    errors = Array(instance.error_message).join('<br/>')
    %(<span class="field-error-input">#{html_tag}<span class="validation-error">#{errors}</span></span>).html_safe
  else
    %(<span class="field-error-input">#{html_tag}</span>).html_safe
  end
end
