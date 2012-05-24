class HomeController < ApplicationController

  layout 'empty', :only => [:index]
  skip_before_filter :clear_family_registration
  skip_before_filter :require_confirmation
  

  def index
  end

end
