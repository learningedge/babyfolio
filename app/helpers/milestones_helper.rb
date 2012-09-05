module MilestonesHelper

  def display_ms_field field, text, opts={}
    if field.present?
        result = '<p class="italic">' + text + '</p>'
        result += @child.replace_forms(field)
        result += '<hr />' if opts[:hr]
        return result.html_safe
    end
  end
end
