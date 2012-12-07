namespace :excel do
  
#  desc "Migrating moment_tags to db from excel file"
#  task :moment_tags => :environment do
#    print "------ migrating moment_tags ------\n"
#
#    MomentTag.delete_all
#
#    @file_path = 'public/SmarterFolioTagsFramework.xls'
#
#    print "LearnerTagsSpreadsheet: Competenses/Abilities..................................\n"
#
#    @main_category = MomentTag.create(:name => "A Striking Developments (Reveals Insight into who your child is)")
#    @category_one_level0 = MomentTag.create(:name => "Competenses/Abilities", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
#
#    file = Excel.new(@file_path)
#    file.default_sheet = file.sheets.at(1)
#
#    @index = 0
#
#    2.upto(file.last_row) do |line|
#
#      name = file.cell(line,'A')
#      name.strip! unless name.blank?
#
#      require_level_affinity  = file.cell(line,'B')
#      unless require_level_affinity.blank?
#        require_level_affinity = require_level_affinity.downcase
#        require_level_affinity.strip!
#      end
#
#      value_type = file.cell(line,'C')
#      value_range = file.cell(line,'D')
#
#      parent_question = file.cell(line,"E")
#      parent_question.strip! unless parent_question.blank?
#
#      levels = Array.new
#      levels[1] = file.cell(line,"H")
#      levels[2] = file.cell(line,"I")
#      levels[3] = file.cell(line,"J")
#      levels[4] = file.cell(line,"K")
#      levels.each {|level| level.strip! unless level.blank?}
#
#      moment_tags = Array.new
#      moment_tags[0] = @category_one_level0
#
#      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s
#
#      if ( !levels[1].blank? or
#           (!levels[1].blank? and !levels[2].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?)
#          ) and require_level_affinity == "affinity"
#
#        pp levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect
#
#        1.upto(4) do |level|
#          unless levels[level].blank?
#            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
#            if moment_tags[level].blank?
#              if levels[level+1].blank?
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#              else
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              end
#            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
#              moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#            end
#            level_hierarchy += ">>" + moment_tags[level].id.to_s
#          end
#        end
#      end
#    end
#
#    print "DONE\n"
#
#    print "LearnerTagsSpreadsheet: Concepts/Subjects......................................\n"
#
#    file = Excel.new(@file_path)
#    file.default_sheet = file.sheets.at(2)
#
#    @category_two_level0 = MomentTag.create(:name => "Concepts/Subjects", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
#    @index = 0
#
#    2.upto(file.last_row) do |line|
#
#      name = file.cell(line,'A')
#      name.strip! unless name.blank?
#
#      require_level_affinity  = file.cell(line,'B')
#      unless require_level_affinity.blank?
#        require_level_affinity = require_level_affinity.downcase
#        require_level_affinity.strip!
#      end
#
#      value_type = file.cell(line,'C')
#      value_range = file.cell(line,'D')
#
#      parent_question = file.cell(line,"E")
#      parent_question.strip! unless parent_question.blank?
#
#      levels = Array.new
#      levels[1] = file.cell(line,"H")
#      levels[2] = file.cell(line,"I")
#      levels[3] = file.cell(line,"J")
#      levels[4] = file.cell(line,"K")
#      levels[5] = file.cell(line,"L")
#      levels.each {|level| level.strip! unless level.blank?}
#
#      moment_tags = Array.new
#      moment_tags[0] = @category_two_level0
#
#      level_hierarchy = @main_category.id.to_s + ">>" + @category_two_level0.id.to_s
#
#      if ( !levels[1].blank? or
#           (!levels[1].blank? and !levels[2].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank?)
#       ) and require_level_affinity == "affinity"
#
#        pp require_level_affinity + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect + " -> " + levels[5].inspect
#
#        1.upto(5) do |level|
#          unless levels[level].blank?
#            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
#            if moment_tags[level].blank?
#              if levels[level+1].blank?
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :require_level_affinity => require_level_affinity,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#              else
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              end
#            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
#              moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :require_level_affinity => require_level_affinity,
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#            end
#            level_hierarchy += ">>" + moment_tags[level].id.to_s
#          end
#        end
#      end
#    end
#
#
#    print "DONE\n"
#
#
#    print "LearnerTagsSpreadsheet: Charakter/Dispositions......................................\n"
#
#    file = Excel.new(@file_path)
#    file.default_sheet = file.sheets.at(3)
#
#    @category_three_level0 = MomentTag.create(:name => "Character/Dispositions", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
#    @index = 0
#
#    2.upto(file.last_row) do |line|
#
#      name = file.cell(line,'A')
#      name.strip! unless name.blank?
#
#      require_level_affinity  = file.cell(line,'B')
#      unless require_level_affinity.blank?
#        require_level_affinity = require_level_affinity.downcase
#        require_level_affinity.strip!
#      end
#
#      value_type = file.cell(line,'C')
#      value_range = file.cell(line,'D')
#
#      parent_question = file.cell(line,"E")
#      parent_question.strip! unless parent_question.blank?
#
#      levels = Array.new
#      levels[1] = file.cell(line,"G")
#      levels[2] = file.cell(line,"H")
#      levels[3] = file.cell(line,"I")
#      levels[4] = file.cell(line,"J")
#      levels.each {|level| level.strip! unless level.blank?}
#
#      moment_tags = Array.new
#      moment_tags[0] = @category_three_level0
#
#      level_hierarchy = @main_category.id.to_s + ">>" + @category_three_level0.id.to_s
#
#      if ( !levels[1].blank? or
#           (!levels[1].blank? and !levels[2].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?)
#       ) and require_level_affinity == "affinity"
#
#        pp require_level_affinity + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect
#
#        1.upto(4) do |level|
#          unless levels[level].blank?
#            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
#            if moment_tags[level].blank?
#              if levels[level+1].blank?
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :require_level_affinity => require_level_affinity,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#              else
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              end
#            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
#              moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :require_level_affinity => require_level_affinity,
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#            end
#            level_hierarchy += ">>" + moment_tags[level].id.to_s
#          end
#        end
#      end
#    end
#
#
#    print "DONE\n"
#
#
#    print "LearnerTagsSpreadsheet: Real World Interest areas......................................\n"
#
#    file = Excel.new(@file_path)
#    file.default_sheet = file.sheets.at(4)
#
#    @main_category = MomentTag.create(:name => "A Place, Thing or Situation of Interest")
#    @category_one_level0 = MomentTag.create(:name => "Real World Interest areas", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
#    @index = 0
#
#    2.upto(file.last_row) do |line|
#
#      name = file.cell(line,'A')
#      name.strip! unless name.blank?
#
#      require_level_affinity  = file.cell(line,'B')
#      unless require_level_affinity.blank?
#        require_level_affinity = require_level_affinity.downcase
#        require_level_affinity.strip!
#      end
#
#      value_type = file.cell(line,'C')
#      value_range = file.cell(line,'D')
#
#      parent_question = file.cell(line,"E")
#      parent_question.strip! unless parent_question.blank?
#
#      levels = Array.new
#      levels[1] = file.cell(line,"G")
#      levels[2] = file.cell(line,"H")
#      levels[3] = file.cell(line,"I")
#      levels[4] = file.cell(line,"J")
#      levels[5] = file.cell(line,"K")
#      levels[6] = file.cell(line,"L")
#      levels[7] = file.cell(line,"M")
#      levels.each {|level| level.strip! unless level.blank?}
#
#      moment_tags = Array.new
#      moment_tags[0] = @category_one_level0
#
#      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s
#
#      if ( !levels[1].blank? or
#           (!levels[1].blank? and !levels[2].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank? and !levels[6].blank?) or
#           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank? and !levels[6].blank? and !levels[7].blank?)
#       ) and require_level_affinity == "affinity"
#
#        pp require_level_affinity.inspect + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect + " -> " + levels[5].inspect + " -> " + levels[6].inspect + " -> " + levels[7].inspect
#
#        1.upto(7) do |level|
#          unless levels[level].blank?
#            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
#            if moment_tags[level].blank?
#              if levels[level+1].blank?
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :require_level_affinity => require_level_affinity,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#              else
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              end
#            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
#              moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :require_level_affinity => require_level_affinity,
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#            end
#            level_hierarchy += ">>" + moment_tags[level].id.to_s
#          end
#        end
#      end
#    end
#
#
#    print "DONE\n"
#
#    print "LearnerTagsSpreadsheet: People/Relationships......................................\n"
#
#    file = Excel.new(@file_path)
#    file.default_sheet = file.sheets.at(5)
#
#    @main_category = MomentTag.create(:name => "People/Relationships")
#    @category_one_level0 = MomentTag.create(:name => "People Assets", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
#    @index = 0
#
#    2.upto(file.last_row) do |line|
#
#      name = file.cell(line,'A')
#      name.strip! unless name.blank?
#
#      require_level_affinity  = file.cell(line,'B')
#      unless require_level_affinity.blank?
#        require_level_affinity = require_level_affinity.downcase
#        require_level_affinity.strip!
#      end
#
#      value_type = file.cell(line,'C')
#      value_range = file.cell(line,'D')
#
#      parent_question = file.cell(line,"E")
#      parent_question.strip! unless parent_question.blank?
#
#      levels = Array.new
#      levels[1] = file.cell(line,"F")
#      levels[2] = file.cell(line,"G")
#      levels.each {|level| level.strip! unless level.blank?}
#
#      moment_tags = Array.new
#      moment_tags[0] = @category_one_level0
#
#      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s
#
#      if ( !levels[1].blank? or
#           (!levels[1].blank? and !levels[2].blank?)
#       ) #and require_level_affinity == "affinity"
#
#        pp require_level_affinity.inspect + " :::: " + levels[1].inspect + " -> " + levels[2].inspect
#
#        1.upto(2) do |level|
#          unless levels[level].blank?
#            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
#            if moment_tags[level].blank?
#              if levels[level+1].blank?
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :value_type => value_type,
#                  :require_level_affinity => require_level_affinity,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              else
#
#                moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#
#              end
#            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
#              moment_tags[level] = MomentTag.create(
#                  :name => levels[level],
#                  :require_level_affinity => require_level_affinity,
#                  :value_type => value_type,
#                  :value_range => value_range,
#                  :parent_question => parent_question,
#                  :moment_tag_id => moment_tags[level-1].id,
#                  :level => level,
#                  :level_hierarchy => level_hierarchy
#                )
#            end
#            level_hierarchy += ">>" + moment_tags[level].id.to_s
#          end
#        end
#      end
#    end
#
#
#    print "DONE\n"
#
#  end

#  desc "Checking updated moments"
#  task :checking => :environment do
#    @parent_name = "State of Matter"
#
#    @moment_tags = MomentTag.where(["moment_tag_id IS NULL"])
#
#    pp "************************************"
#
#    @moment_tags.each do |moment_tag|
#      pp moment_tag.id.to_s + ":::" + moment_tag.require_level_affinity.to_s + ":::" + moment_tag.name.to_s + ":::" + moment_tag.parent_question.to_s + ":::" + moment_tag.level_hierarchy.to_s + ":::" + moment_tag.level.to_s
#    end
#
#    pp "************************************"
#    pp "Children of \"" + @parent_name + "\""
#    pp "************************************"
#
#    @children_tags = @moment_tags.first.children_tags
#    @children_tags.each do |child_tag|
#      pp child_tag.id.to_s + ":::" + child_tag.require_level_affinity.to_s + ":::" + child_tag.name.to_s + ":::" + child_tag.value_type.to_s + ":::" + child_tag.parent_question.to_s + ":::" + child_tag.parent_tag.name + ":::" + child_tag.level_hierarchy.to_s + ":::" + child_tag.level.to_s
#    end
#  end


  desc "Migrating questions to database from excel file - 'ProfileQs.xls'"
  task :questions => :environment do
    
    print "------ migrating questions ------ \n"    

    Question.delete_all
    Answer.delete_all

    file = Excel.new('public/ProfileQs.xls')
    file.default_sheet = file.sheets.at(1)    

    cat = "none"
    age = -1

    2.upto(file.last_row) do |line|
      new_cat = file.cell(line,'C')
      desc  = file.cell(line,'F')
      ms_title = file.cell(line, 'K')
      new_age = Integer(file.cell(line,'J'))
      lw_index = file.cell(line, 'I').gsub(/\s+/, "")
      lw_index =lw_index.downcase.gsub('lw', '') if lw_index

      cat = new_cat
      age = new_age

      mid = new_cat + "_" + age.to_s + "_" + lw_index


      Question.create(:text => desc, :category => cat, :age => age, :mid => mid, :milestone_title => ms_title)      
      ms = Milestone.find_by_mid(mid)

      qs_header =  "#{age.to_s} / #{cat} / #{lw_index} \n"
      
      if ms 
      	 mt = ms.title.gsub(/["'.:]/, "").strip.downcase[0,15]
	 qt = ms_title.gsub(/["'.:]/, "").strip.downcase[0,15]
	 if qt != mt
      	  print qs_header
      	  milestone_title = "M) #{ ms.title.gsub(/["'.]/, "").strip } \n\n"
      	  print "Q) #{ms_title.gsub(/["'.]/, "").strip } \n"
	  print milestone_title
	 end
      else
         print qs_header
      	 print "Q) #{ms_title.gsub(/["'.]/, "").strip[0,15] } \n"
	 print "//===== No milestone for #{mid} ====//\n\n"

      end   
    end
    
  end

  desc "Migratinog milestones from excel file = 'Milestones_Sample'"
  task :milestones => :environment do
    pp "------ migrating milestones ------ "

    Milestone.delete_all
    upload_milestones('public/milestones_0_12.xls')
    upload_milestones('public/milestones_12_60.xls')
    
  end

  desc "Migrating the all excell documents to database"
  task :all do

    print "## Migrating all excel documents to database started!\n"
      
      Rake::Task['excel:questions'].invoke
      Rake::Task['excel:milestones'].invoke

    print "## DONE!!!\n"
  end

  desc 'Create YAML test fixtures from data in an existing database. Defaults to development database. Set RAILS_ENV to development.'

  task :generate_fixtures => :environment do
    sql = "SELECT * FROM %s"
    tables = ["questions", "moment_tags"]
    ActiveRecord::Base.establish_connection
    tables.each do |table_name|
      i = "000"
      File.open("#{Rails.root}/test/fixtures/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) {|hash, record|
          hash["#{table_name}_#{i.succ!}"] = record
          hash
        }.to_yaml
      end
    end
  end

private 
  def upload_milestones file_path
    file = Excel.new(file_path)
    file.default_sheet = file.sheets.at(0)
    2.upto(file.last_row) do |line|      
      age = Integer(file.cell(line, 'A'))
      cat = file.cell(line, 'B')
      lw_no = file.cell(line, 'C')
      lw_no = lw_no.downcase.gsub("lw", "") if lw_no

      if age.present? && cat.present? && lw_no.present?
      	mid = cat + "_" + age.to_s + "_" + lw_no
        title = file.cell(line, 'D')
        research_background = file.cell(line, 'F')
        research_references = file.cell(line, 'G')
        observation_title = file.cell(line, 'H')
        observation_subtitle = file.cell(line, 'I')
        observation_desc = file.cell(line, 'J')
        observation_what_it_means = file.cell(line, 'K')
        other_occurances = file.cell(line, 'L')
        parent_as_partner = file.cell(line, 'N')
        activity_1_title = file.cell(line, 'O')
        activity_1_subtitle = file.cell(line, 'P')
        activity_1_set_up = file.cell(line, 'Q')
        activity_1_response = file.cell(line, 'R')
        activity_1_modification = file.cell(line, 'S')
        activity_1_later_developments = file.cell(line,'T')
        activity_1_learning_benefits = file.cell(line,'U')
        activity_2_title = file.cell(line,'V')
        activity_2_subtitle = file.cell(line,'W')
        activity_2_situation = file.cell(line,'X')
        activity_2_response = file.cell(line,'Y')
        activity_2_modification = file.cell(line,'Z')
        activity_2_later_developments = file.cell(line,'AA')
        activity_2_learning_benefits = file.cell(line,'AB')


        milestone = Milestone.create(
                      :mid => mid,
                      :title => title,
                      :research_background => research_background.to_s.gsub(/\n/, '<br />'),
                      :research_references => research_references.to_s.gsub(/\n/, '<br />'),
                      :observation_title => observation_title.to_s.gsub(/\n/, '<br />'),
                      :observation_subtitle => observation_subtitle.to_s.gsub(/\n/, '<br />'),
                      :observation_desc => observation_desc.to_s.gsub(/\n/, '<br />'),
                      :observation_what_it_means => observation_what_it_means.to_s.gsub(/\n/, '<br />'),
                      :other_occurances => other_occurances.to_s.gsub(/\n/, '<br />'),
                      :parent_as_partner => parent_as_partner.to_s.gsub(/\n/, '<br />'),
                      :activity_1_title => activity_1_title.to_s.gsub(/\n/, '<br />'),
                      :activity_1_subtitle => activity_1_subtitle.to_s.gsub(/\n/, '<br />'),
                      :activity_1_set_up => activity_1_set_up.to_s.gsub(/\n/, '<br />'),
                      :activity_1_response => activity_1_response.to_s.gsub(/\n/, '<br />'),
                      :activity_1_modification => activity_1_modification.to_s.gsub(/\n/, '<br />'),
                      :activity_1_later_developments => activity_1_later_developments.to_s.gsub(/\n/, '<br />'),
                      :activity_1_learning_benefits => activity_1_learning_benefits.to_s.gsub(/\n/, '<br />'),
                      :activity_2_title => activity_2_title.to_s.gsub(/\n/, '<br />'),
                      :activity_2_subtitle => activity_2_subtitle.to_s.gsub(/\n/, '<br />'),
                      :activity_2_situation => activity_2_situation.to_s.gsub(/\n/, '<br />'),
                      :activity_2_response => activity_2_response.to_s.gsub(/\n/, '<br />'),
                      :activity_2_modification => activity_2_modification.to_s.gsub(/\n/, '<br />'),
                      :activity_2_later_developments => activity_2_later_developments.to_s.gsub(/\n/, '<br />'),
                      :activity_2_learning_benefits => activity_2_learning_benefits.to_s.gsub(/\n/, '<br />')
                    )
 	  qs = Question.find_by_mid(milestone.mid);
	  print "Cant find question for #{milestone.mid}.\n" unless qs
        end
      end

        pp "------ DONE for #{file_path}------"
    end	  
end