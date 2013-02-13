class Api::V1::PlayController < ApplicationController
  layout false
  before_filter :require_user

  def show
    milestone = Milestone.find_by_mid(params[:mid])
    @activity = {
      :category => milestone.questions.first.category,
      :mid => milestone.mid,
      :ms_title => current_child.replace_forms(milestone.title, 35),
      :title => milestone.activity_1_title.present? ? current_child.replace_forms(milestone.activity_1_title, 60) : "Title goes here",
      :setup => current_child.replace_forms(milestone.activity_1_set_up, 90),
      :response => current_child.replace_forms(milestone.activity_1_response),
      :variations => current_child.replace_forms(milestone.activity_1_modification),
      :learning_benefits => current_child.replace_forms(milestone.activity_1_learning_benefits),
      :selected => true,
      :likes => milestone.likes.find_by_child_id(current_child.id)
    }

  end

end
