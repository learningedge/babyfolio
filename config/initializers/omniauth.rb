Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :facebook, '	263019473774028', '7c92fcaf00c30a9da772af2de7a2b144'
#  provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
