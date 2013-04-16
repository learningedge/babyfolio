class Page < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :custom_fields
  accepts_nested_attributes_for :custom_fields
  
  def cf slug, size = "admin"
    cf = self.custom_fields.find_by_slug(slug)
    if cf.field_type == "image"
      cf.custom_image.url(size)
    else
      cf.content.html_safe
    end
  end
end
