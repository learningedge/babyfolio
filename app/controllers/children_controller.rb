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
#    if( @user.services.where(:provider => 'facebook').exists?)
#       service = @user.services.where(:provider => 'facebook').first
#           usr = FbGraph::User.me()
#       usr = FbGraph::User.fetch(service.uid, :access_token => service.token)       
#       render :text =>  usr.albums.first.photos.first.source
#    end
#    render :text => current_user.has_facebook_account?.nil? ? "NULL" : "SOMETHING IN IT #{current_user.has_facebook_account?}"
  end

  def edit

    @child = Child.find(params[:id])
    
  end

  def update

    @child = Child.find(params[:id])
    @child.update_attributes(params[:child])
    @child.save
    
    redirect_to :back
  end  
  
end
