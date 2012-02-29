class ChildrenController < ApplicationController

#  before_filter :require_user
#  before_filter :require_confirmation
#  before_filter :require_family

  def show

    @user = current_user
    @families = @user.families
    @selected_family = current_family
    @children = @selected_family.children
    @selected_child ||= params[:child_id].present? ? (@children.select { |c| c.id == params[:child_id].to_i }.first || @children.first) : @children.first
    
    
  end

  def edit

  end

  def update

    redirect_to children_path
  end
end
