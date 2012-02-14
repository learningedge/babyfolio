class HomeController < ApplicationController
  
  before_filter :require_user
  before_filter :require_confirmation

  def index
    
  end
  
end
