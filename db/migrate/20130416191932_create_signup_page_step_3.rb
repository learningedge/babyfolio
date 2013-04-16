class CreateSignupPageStep3 < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Signup Step 3", :slug => "signup_step_3"})

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "left_sidebar_text", 
                         :label => "Left Sidebar Text", 
                         :content => "<strong>We're almost finished!</strong> We just need to know what your baby is actually doing so we can identify the most important developments and tailor the site to your specific baby.",
                         :menu_order => 1, 
                         :field_type => "text_field"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "point_1", 
                         :label => "Point 1", 
                         :content => "Starting with the first intelligence, Language, if you've seen the behavior listed, click \"I have seen this!\" If you haven't seen the behavior, click \"I haven't seen this yet!\"",
                         :menu_order => 2, 
                         :field_type => "text_area"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "point_2", 
                         :label => "Point 2", 
                         :content => "If you clicked \"I have seen this!\" in the first step, keep going until you haven't seen a behavior and then click \"I haven't see this yet!\" If you clicked \"I haven't seen this yet!\" keep going until you've seen a behavior and click \"I have seen this!\" Follow the same process for the next intelligence. Once you've completed the last intelligence, you'll be asked to either continue or add another baby.",
                         :menu_order => 3, 
                         :field_type => "text_area"
                       })
  end

  def down
#    page = Page.find_by_slug("signup_step_3")
#    CustomField.where(:page_id => page.id).delete_all
#    page.delete;
  end
end
