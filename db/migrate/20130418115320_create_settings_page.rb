class CreateSettingsPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Settings", :slug => "settings"})
    
    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title",
                         :label => "Title", 
                         :content => "You can change your account settings and manage your circles here.",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

  end

  def down
    page = Page.find_by_slug("settings")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;    
  end
end
