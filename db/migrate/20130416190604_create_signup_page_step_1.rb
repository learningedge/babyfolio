class CreateSignupPageStep1 < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Signup Step 1", :slug => "signup_step_1"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_image", 
                         :label => "Left Sidebar Image", 
                         :content => "",
                         :menu_order => 1, 
                         :field_type => "image"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_headline", 
                         :label => "Left Sidebar Hedline", 
                         :content => "Have a question?",
                         :menu_order => 2, 
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_content", 
                         :label => "Left Sidebar content", 
                         :content => "<a href='http://www.babyfol.io/contact'>Send us an email</a> and Annie, our Community Manager, will be happy to help you!",
                         :menu_order => 3, 
                         :field_type => "text_area"
                       })

  end

  def down
#    page = Page.find_by_slug("signup_step_1")
#    CustomField.where(:page_id => page.id).delete_all
#    page.delete;
  end
end
