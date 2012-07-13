class MilestonesController < ApplicationController

  layout "none"

  def show
     @milestone = Milestone.find_by_mid(params[:mid])
     @question = Question.find_by_mid(params[:mid])
     @child = current_user.all_user_children.find(params[:child_id])

  end
end
