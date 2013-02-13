class Api::V1::WatchController < ApplicationController
  layout false
  before_filter :require_user

  def show
    milestone = Milestone.find_by_mid(params[:mid])

    @behavior = {
      :category => milestone.questions.first.category,
      :mid => milestone.mid,
      :ms_title => current_child.replace_forms(milestone.title, 35),
      :title => current_child.replace_forms(milestone.get_title, 60),
      :subtitle =>  milestone.observation_subtitle.blank? ? "Subtitle goes here" : current_child.replace_forms(milestone.observation_subtitle),
      :desc => current_child.replace_forms(milestone.observation_desc),
      :examples =>  current_child.replace_forms(milestone.other_occurances),
      :activity_1_title => current_child.replace_forms(milestone.activity_1_title, 40),
      :activity_2_title => current_child.replace_forms(milestone.activity_2_title, 40),
      :activity_1_url => "/api/v1/play/#{milestone.mid}",
      :activity_2_url => "/api/v1/play/#{milestone.mid}",
      :why_important => current_child.replace_forms(milestone.observation_what_it_means),
      :theory => current_child.replace_forms(milestone.research_background),
      :references => current_child.replace_forms(milestone.research_references),
      :time => "current",
      :selected => true
    }
  end

end


