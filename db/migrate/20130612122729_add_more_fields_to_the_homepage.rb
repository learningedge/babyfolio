class AddMoreFieldsToTheHomepage < ActiveRecord::Migration
  def up
    page = Page.find_by_slug("homepage")

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "first_slide", 
                         :label => "First Slide", 
                         :content => "<p>Discover your child's Multiple Intelligences!</p><p>Give us 5 minutes and we'll give you insights into your child's world, for free!<p>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "second_slide", 
                         :label => "Second Slide", 
                         :content => "Created with experts from Harvard University and the Brazelton Institute, and Reggio Emilia programs. Try it out, it's free.",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "third_slide", 
                         :label => "Third Slide", 
                         :content => "<p>&bull; The world keeps getting more competetive.</p>
          <p>&bull; How do you help your baby thrive.</p>
          <p>&bull; Get the BabyFolio advantage and help your baby<br />  become a master player and master life.</p>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })
    
  end

  def down
    page = Page.find_by_slug("homepage")

    custom_field = CustomField.find_by_page_id(page.id, :conditions => { :slug => 'first_slide' })
    custom_field.delete if custom_field

    custom_field = CustomField.find_by_page_id(page.id, :conditions => { :slug => 'second_slide' })
    custom_field.delete if custom_field

    custom_field = CustomField.find_by_page_id(page.id, :conditions => { :slug => 'third_slide' })
    custom_field.delete if custom_field
  end

end
