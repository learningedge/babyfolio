class Page < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :custom_fields
  accepts_nested_attributes_for :custom_fields

  FORMS = {
    /\[He\/She\]/ => ['He', 'She'],
    /\[he\/she\]/ => ['he', 'she'],
    /\[His\/Her\]/ => ['His', 'Her'],    
    /\[his\/her\]/ => ['his', 'her'],    
    /\[Him\/Her\]/ => ['Him', 'Her'],    
    /\[him\/her\]/ => ['him', 'her'],    
    /\[His\/Hers\]/ => ['His', 'Hers'],    
    /\[his\/hers\]/ => ['his', 'hers'],
    /\[himself\/herself\]/ => ['himself', 'herself'],
    /\[Himself\/Herself\]/ => ['Himself', 'Herself']
  }
  
  def cf slug, size = "admin"
    cf = self.custom_fields.find_by_slug(slug)
    if cf.field_type == "image"
      cf.custom_image.url(size)
    else
      cf.content.html_safe
    end
  end
  
end
