# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Answer.delete_all
Attachment.delete_all
Child.delete_all
Comment.delete_all
Like.delete_all
Log.delete_all
Media.destroy_all
Milestone.delete_all
Question.delete_all
Relation.delete_all
TimelineEntry.delete_all
TimelineMeta.delete_all
User.delete_all

@user = User.new(:email => 'admin@codephonic.com', :password => 'qwerty', :password_confirmation => 'qwerty', :email_confirmed => 1, :is_admin => true)
@user.reset_perishable_token
@user.save

Rake::Task['excel:all'].invoke




