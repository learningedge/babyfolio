class ChildrenController < ApplicationController

#  before_filter :require_user
#  before_filter :require_confirmation
before_filter :require_family
before_filter :require_family_with_child

  def show

    @user = current_user
    @families = @user.families
    @selected_family = current_family
    @children = @selected_family.children
    @selected_child ||= params[:child_id].present? ? (@children.select { |c| c.id == params[:child_id].to_i }.first || @children.first) : @children.first    
    
  end

  def edit

    require 'flickraw'


    FlickRaw.api_key="711439ce527642e0fee2d5fc76f2affe"
    FlickRaw.shared_secret="d0b79889905ec211"

    begin
      @flickr_images = flickr.photos.search(:user_id => current_user.flickr_id)
    rescue FlickRaw::FailedResponse
      if error?(2)
        @flickr_info = 'nieznany login'
      else
        @flickr_info = 'nie ma parametru'
      end
      
#    rescue FlickRaw
#      
#    else

    end
   
    @child = Child.find(params[:id])

    
  end

  def update
    
    @child = Child.find(params[:id])
    @child.update_attributes(params[:child])
    @child.save
    
    redirect_to :back
  end  
  
end
