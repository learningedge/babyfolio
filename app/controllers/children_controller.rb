class ChildrenController < ApplicationController

  def show

    @user = current_user
    @families = @user.families
    @selected_family = current_family
    @children = @selected_family.children
    @selected_child ||= params[:id].present? ? (@children.select { |c| c.id == params[:id].to_i }.first || @children.first) : @children.first
    
    
  end

  def edit

  end

  def update

    redirect_to children_path
  end
end
