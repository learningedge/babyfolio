class CreateHomepagePage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Homepage", :slug => "homepage"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title", 
                         :label => "Watch text", 
                         :content => "BabyFolio provides the best tools for you to raise a happy, smart child with the foundations to thrive in the 21st century.",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id,
                         :slug => "left_sidebar_image",
                         :label => "Left sidebar image",
                         :menu_order => 2,
                         :field_type => "image"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_text", 
                         :label => "Left sidebar text", 
                         :content => "Created with experts from Harvard University and the Brazelton Institute, and Reggio Emilia programs. It's FREE!",
                         :menu_order => 3, 
                         :field_type => "text_field"
                       })

    CustomField.create({ 
                         :page_id => page.id, 
                         :slug => "watch_text", 
                         :label => "Watch text", 
                         :content => "Identify your baby's important developments.",
                         :menu_order => 4,
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "reflect_text", 
                         :label => "Reflect text", 
                         :content => "Understand your baby's profile of development and how you can help.",
                         :menu_order => 5,
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "play_text", 
                         :label => "Play text", 
                         :content => "Get the right play at the right time to support your baby's specific developments.",
                         :menu_order => 6,
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "plus_display_headline", 
                         :label => "Plus Display headline", 
                         :content => "*Plus you can share your Babyfolio!",
                         :menu_order => 7,
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "plus_display_text", 
                         :label => "Plus Display text", 
                         :content => "Better coordinate with close family & friends who truly care about your baby.",
                         :menu_order => 8,
                         :field_type => "text_field"
                       })
    
  end

  def down
    page = Page.find_by_slug("homepage")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;
  end
end
