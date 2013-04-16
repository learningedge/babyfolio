class CreateSignupPageStep2 < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Signup Step 2", :slug => "signup_step_2"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_headline", 
                         :label => "Left Sidebar Hedline", 
                         :content => "Joining BabyFolios",
                         :menu_order => 1, 
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_content", 
                         :label => "Left Sidebar content", 
                         :content => "Want to join a BabyFolio that already exists? Ask the parents to invite you with the email address you just submitted",
                         :menu_order => 3, 
                         :field_type => "text_area"
                       })
  end

  def down
#    page = Page.find_by_slug("signup_step_2")
#    CustomField.where(:page_id => page.id).delete_all
#    page.delete;
  end
end
