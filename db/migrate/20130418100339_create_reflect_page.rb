class CreateReflectPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Reflect", :slug => "reflect"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title",
                         :label => "Title", 
                         :content => "Here are [CHILD_NAME]'s most important developments:",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_headline", 
                         :label => "Left Sidebar Headline", 
                         :content => "<h4>[CHILD_NAME]' Development</h4>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_text", 
                         :label => "Left Sidebar Text", 
                         :content => "Click on any bar in the graph for more information.",
                         :menu_order => 3, 
                         :field_type => "wysiwyg"
                       })
    
    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_activities", 
                         :label => "Right Content Activities:", 
                         :content => "<h5>Support their development with these activites:</h5>",
                         :menu_order => 4, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "success_timeline_messge", 
                         :label => "Success timeline Message", 
                         :content => "You have successfully posted to [CHILD_NAME]'s Timeline",
                         :menu_order => 10, 
                         :field_type => "wysiwyg"
                       })


  end

  def down
    page = Page.find_by_slug("reflect")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;
  end
end
