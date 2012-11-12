module ChildrenHelper

  def activity_pagination page, per_page, total_activities,  offset_start, offset_end
    offset_start += 1
    offset_end += 1
    total_pages = (total_activities.to_f / per_page).ceil
    html = '<div class="pagination">'
    prev_link = link_to "<", play_children_path(:page => page - 1) if (page - 1 > 0)
    next_link = link_to ">", play_children_path(:page => page + 1) if total_pages > page
    middle = "#{offset_start} - #{offset_end} of #{total_activities}"
    html += "#{prev_link} #{middle} #{next_link}</div>"

    return html.html_safe
  end
end
