# Load the rails application
require File.expand_path('../application', __FILE__)
require "pp"

# Initialize the rails application
Babyfolio::Application.initialize!

Babyfolio::Application.configure  do
  config.FLICKR_KEY = '711439ce527642e0fee2d5fc76f2affe'
  config.FLICKR_SECRET = 'd0b79889905ec211'

  config.YOUTUBE_KEY = '821905120152.apps.googleusercontent.com'
  config.YOUTUBE_SECRET = 'q9XDXCtGECoa0clbFMeVGuKT'

end


