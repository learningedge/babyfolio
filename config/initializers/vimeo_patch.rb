OmniAuth::Strategies::Vimeo.class_eval do
    def request_phase
      options[:authorize_params] = {:permission => options[:scope]} if options[:scope]
      super
    end
end
