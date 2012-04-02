class QuestionsController < ApplicationController

  def index
    @child= my_family.children.first
    render :text => @child.months_old
  end

end
