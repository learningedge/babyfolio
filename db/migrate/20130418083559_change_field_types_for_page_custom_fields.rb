class ChangeFieldTypesForPageCustomFields < ActiveRecord::Migration
  def up
    CustomField.where('field_type IN ("text_field", "text_area")').update_all(:field_type => 'wysiwyg');
  end

  def down
  end
end
