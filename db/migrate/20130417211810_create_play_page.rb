class CreatePlayPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Play", :slug => "play"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title",
                         :label => "Title", 
                         :content => "Here is a list of recommended play activities for [CHILD_NAME] based on [his/her] current development.",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_text", 
                         :label => "Left Sidebar Text", 
                         :content => "Click on the title for a detailed description and associated behavioral milestones.",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

  end
  def down
    page = Page.find_by_slug("play")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;
  end
end
