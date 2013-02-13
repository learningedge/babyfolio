class RelationsController < ApplicationController

  before_filter :require_user
  before_filter :require_child 

  def destroy
    @relation = Relation::find(params[:id])
    @relation.delete

    redirect_to :back
  end

  
end
