# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)





Attachment.delete_all
Child.delete_all
Family.delete_all
Media.delete_all
Moment.delete_all
Relation.delete_all
Service.delete_all
User.delete_all

@admin = User.where(:email => 'admin@codephonic.com');
@admin.each do |admin|

admin.families.parenting_families.each do |family|
  puts family.inspect
  family.children.each do |child|
    child.moments.destroy_all
    child.destroy
  end
  family.destroy
end

admin.moments.destroy_all
admin.services.destroy_all
admin.destroy

end


@user = User.new(:email => 'admin@codephonic.com', :password => 'admin', :password_confirmation => 'admin', :email_confirmed => 1, :is_admin => true)
@user.reset_perishable_token
@user.save



Rake::Task['excel:all'].invoke




