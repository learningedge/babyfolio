class CustomField < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :page

#  scope :by_slug, lambda {|slug|}


  has_attached_file :custom_image,
  :styles => {
    :admin => "300x300>",
    :homepage => "326x395#",
    :reg_step1 => "67x98#"
  },
  :storage => :s3,
  :s3_credentials => YAML.load_file("#{Rails.root}/config/s3.yml"),  #"#{RAILS_ROOT}/config/s3.yml", 
  :path => "/pages/:style/:id/:filename"

end
