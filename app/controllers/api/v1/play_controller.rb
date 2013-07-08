class Api::V1::PlayController < ApplicationController
  layout false
  before_filter :require_user

  def show
    @page = Page.find_by_slug("play");
    
    a = Activity.includes(:behaviour).find_by_id(params[:aid])

    a_likes = a.likes.find_by_child_id(current_child.id)
    likes = a_likes.value unless a_likes.nil?
    @activity = {
      :category => a.category,
      :aid => a.id,
      :b_title => current_child.replace_forms(a.behaviour.title_past),
      :bid => a.behaviour.id,
      :title => current_child.replace_forms(a.title),
      :action => current_child.replace_forms(a.action),
      :actioned => current_child.replace_forms(a.actioned),
      :desc_short => current_child.replace_forms(a.description_short),
      :desc_long => current_child.replace_forms(a.description_long),
      :variation1 => current_child.replace_forms(a.variation1),
      :variation2 => current_child.replace_forms(a.variation2),                         
      :learning_benefit => current_child.replace_forms(a.learning_benefit),
      :likes => likes
    }
  end


=begin
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
=end

end
