class ChangeFieldTypesForPageCustomFields < ActiveRecord::Migration
  def up
    CustomField.where('field_type = "text_field" OR field_type = "text_area"').update_all(:field_type => 'wysiwyg');
  end

  def down
  end
end
