class RelationsController < ApplicationController
  
  def destroy

    @relation = Relation::find(params[:id])
    @relation.delete

    redirect_to :back
  end
  
end
