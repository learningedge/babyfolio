class CreateWatchPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Watch", :slug => "watch"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title",
                         :label => "Title", 
                         :content => "Here are upcoming developmental behaviors [CHILD_NAME] will exhibit..",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_headline", 
                         :label => "Left Sidebar Headline", 
                         :content => "<h4>Have you seen [CHILD_NAME] do this yet?</h4>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_text", 
                         :label => "Left Sidebar Text", 
                         :content => "if yes, click on the checkmark. Or click on a title for more information. You can also uncheck a behavior.",
                         :menu_order => 3, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_examples", 
                         :label => "Examples (Right content)", 
                         :content => "<h5>Examples</h5>",
                         :menu_order => 4, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_recommended", 
                         :label => "Recommanded Play Activities (Right content)", 
                         :content => "<h5>Recommanded Play Activities</h5>",
                         :menu_order => 5, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_why_important", 
                         :label => "Why Is this Important (Right content)", 
                         :content => "<h5>Why Is This Important?</h5>",
                         :menu_order => 6, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_theory", 
                         :label => "Theory (Right content)", 
                         :content => "<h5>Theory</h5>",
                         :menu_order => 7, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_references", 
                         :label => "References (Right content)", 
                         :content => "<h5>References</h5>",
                         :menu_order => 8, 
                         :field_type => "wysiwyg"
                       })


    

  end

  def down
    page = Page.find_by_slug("watch")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;
  end
end
