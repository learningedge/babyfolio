class CreateSubnavToPlayPage < ActiveRecord::Migration
  def up
    page = Page.find_by_slug("play")

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_variations", 
                         :label => "Variations (Right content)", 
                         :content => "<h5>Variations</h5>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_what_did_we_just_do", 
                         :label => "What Did We Just Do (Right content)", 
                         :content => "<h5>What Did We Just Do?</h5>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "right_sidebar_watch", 
                         :label => "Watch title (Right content)", 
                         :content => "<h5>This Is Good For [CHILD_NAME] Because [He/She] Has:</h5>",
                         :menu_order => 3, 
                         :field_type => "wysiwyg"
                       })
  end

  def down
    page = Page.find_by_slug("play")
    CustomField.where(:page_id => page.id).where(:slug => ["right_sidebar_variations", "right_sidebar_what_did_we_just_do", "right_sidebar_watch"]).delete_all
  end
end
