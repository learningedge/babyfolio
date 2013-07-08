class Api::V1::WatchController < ApplicationController
  layout false
  before_filter :require_user


  def show
    @page = Page.find_by_slug("watch");
    beh = Behaviour.find(params[:bid])
    time = "current"     

    @behaviour = {
      :category => beh.category,
      :time => time,
      :bid => beh.id,
      :title => current_child.replace_forms(beh.title_present),
      :title_past => current_child.replace_forms(beh.title_past),
      :desc_short => current_child.replace_forms(beh.description_short),
      :desc_long => current_child.replace_forms(beh.description_long),
      :example1 => current_child.replace_forms(beh.example1),
      :example2 => current_child.replace_forms(beh.example2),
      :example3 => current_child.replace_forms(beh.example3),
      :activities => beh.activities,
      :why_important => current_child.replace_forms(beh.why_important),
      :parenting_tip1 => current_child.replace_forms(beh.parenting_tip1),
      :parenting_tip2 => current_child.replace_forms(beh.parenting_tip2),
      :theory => current_child.replace_forms(beh.theory),
      :references => current_child.replace_forms(beh.references),
    }

  end

end


