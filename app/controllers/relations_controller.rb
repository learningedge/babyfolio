class RelationsController < ApplicationController
  before_filter :require_parent
  
  def destroy
    @relation = Relation::find(params[:id])
    @relation.delete

    redirect_to :back
  end
  
end
