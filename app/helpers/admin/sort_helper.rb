module Admin::SortHelper

  def sort_link name, sort_field, options={}, html_options={}
    is_active = params[:sort] && params[:sort].include?(sort_field)
    options[:class] ||= ""
    options[:class] += ' active' if is_active
    is_asc = is_active && params[:sort] && !params[:sort].include?('desc')
    sort_field += ' desc' if is_asc
    ico = is_active ? (is_asc ? "/images/admin/ico_asc.png" : "/images/admin/ico_desc.png") : ""
    link = link_to(url_for(params.merge(:sort => sort_field)), options, html_options) do
      raw(is_active ? "<img src=\"#{ico}\" />" : "")+name
    end
    return link
  end

end
