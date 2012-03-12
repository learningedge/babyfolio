class HomeController < ApplicationController

  layout 'empty', :only => [:index]
  before_filter :require_user, :only => [:socials]
  before_filter :require_confirmation => [:socials]

  def index
    
  end

  def interior
    
  end

  def socials
  end

end
