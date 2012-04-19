module MomentsHelper
  

def moment_tags_list moment_tag_element, level=0

  moment_tags = moment_tag_element.children_tags
  return_string = ""
  
  unless moment_tags.blank?
    
    return_string += "<ul class='level-#{level} #{moment_tag_element.id}' level=#{level}>"
    tmp_moment_tags_list = nil
    moment_tags.each_index do |index|
      moment_tag = moment_tags[index]

      (!moment_tags[index+1].nil? and moment_tag.name == moment_tags[index+1].name) ? next_element_same = true : next_element_same = false
      (!(moment_tag == moment_tags.first) and moment_tag.name == moment_tags[index-1].name) ? prev_element_same = true : prev_element_same = false
      
      unless prev_element_same
        return_string += "<li><div><div id='#{moment_tag.id}' class='moment-tag "
        return_string += "static" if moment_tag.parent_question.blank?
        return_string += "'>"
        tmp_moment_tags_list = moment_tags_list moment_tag, (moment_tag.level.to_i + 1)
      end
      
      return_string += render :partial => 'moment_tag', :locals => {:moment_tag => moment_tag, :prev_element_same => prev_element_same, :next_element_same => next_element_same}

      unless next_element_same
        return_string += "</div></div>"
        return_string += tmp_moment_tags_list
        return_string += "</li>"
      end
    end
    return_string += "</ul>"
  end
  return return_string
end

end
