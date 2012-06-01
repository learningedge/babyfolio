namespace :excel do
  
  desc "Migrating moment_tags to db from excel file"
  task :moment_tags => :environment do
    print "------ migrating moment_tags ------\n"

    MomentTag.delete_all

    @file_path = 'public/SmarterFolioTagsFramework.xls'

    print "LearnerTagsSpreadsheet: Competenses/Abilities..................................\n"

    @main_category = MomentTag.create(:name => "A Striking Developments (Reveals Insight into who your child is)")
    @category_one_level0 = MomentTag.create(:name => "Competenses/Abilities", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)

    file = Excel.new(@file_path)
    file.default_sheet = file.sheets.at(1)
    
    @index = 0
    
    2.upto(file.last_row) do |line|
      
      name = file.cell(line,'A')
      name.strip! unless name.blank?
      
      require_level_affinity  = file.cell(line,'B')
      unless require_level_affinity.blank?
        require_level_affinity = require_level_affinity.downcase
        require_level_affinity.strip!
      end
      
      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')

      parent_question = file.cell(line,"E")
      parent_question.strip! unless parent_question.blank?

      levels = Array.new
      levels[1] = file.cell(line,"H")
      levels[2] = file.cell(line,"I")
      levels[3] = file.cell(line,"J")
      levels[4] = file.cell(line,"K")      
      levels.each {|level| level.strip! unless level.blank?}
      
      moment_tags = Array.new
      moment_tags[0] = @category_one_level0

      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s

      if ( !levels[1].blank? or
           (!levels[1].blank? and !levels[2].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?)           
          ) and require_level_affinity == "affinity"

        pp levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect
        
        1.upto(4) do |level|
          unless levels[level].blank?
            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
            if moment_tags[level].blank?
              if levels[level+1].blank?

                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
              else
                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )

              end
            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
              moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
            end
            level_hierarchy += ">>" + moment_tags[level].id.to_s
          end          
        end
      end
    end

    print "DONE\n"
  
    print "LearnerTagsSpreadsheet: Concepts/Subjects......................................\n"

    file = Excel.new(@file_path)
    file.default_sheet = file.sheets.at(2)

    @category_two_level0 = MomentTag.create(:name => "Concepts/Subjects", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
    @index = 0

    2.upto(file.last_row) do |line|

      name = file.cell(line,'A')
      name.strip! unless name.blank?

      require_level_affinity  = file.cell(line,'B')
      unless require_level_affinity.blank?
        require_level_affinity = require_level_affinity.downcase 
        require_level_affinity.strip!         
      end

      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')

      parent_question = file.cell(line,"E")
      parent_question.strip! unless parent_question.blank?

      levels = Array.new
      levels[1] = file.cell(line,"H")
      levels[2] = file.cell(line,"I")
      levels[3] = file.cell(line,"J")
      levels[4] = file.cell(line,"K")
      levels[5] = file.cell(line,"L")
      levels.each {|level| level.strip! unless level.blank?}

      moment_tags = Array.new
      moment_tags[0] = @category_two_level0

      level_hierarchy = @main_category.id.to_s + ">>" + @category_two_level0.id.to_s

      if ( !levels[1].blank? or
           (!levels[1].blank? and !levels[2].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank?)
       ) and require_level_affinity == "affinity"

        pp require_level_affinity + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect + " -> " + levels[5].inspect

        1.upto(5) do |level|
          unless levels[level].blank?
            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
            if moment_tags[level].blank?
              if levels[level+1].blank?

                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :require_level_affinity => require_level_affinity,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
              else
                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )

              end
            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
              moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :require_level_affinity => require_level_affinity,
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
            end
            level_hierarchy += ">>" + moment_tags[level].id.to_s
          end
        end
      end
    end
      

    print "DONE\n"


    print "LearnerTagsSpreadsheet: Charakter/Dispositions......................................\n"

    file = Excel.new(@file_path)
    file.default_sheet = file.sheets.at(3)

    @category_three_level0 = MomentTag.create(:name => "Character/Dispositions", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
    @index = 0

    2.upto(file.last_row) do |line|

      name = file.cell(line,'A')
      name.strip! unless name.blank?

      require_level_affinity  = file.cell(line,'B')
      unless require_level_affinity.blank?
        require_level_affinity = require_level_affinity.downcase
        require_level_affinity.strip!
      end

      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')

      parent_question = file.cell(line,"E")
      parent_question.strip! unless parent_question.blank?

      levels = Array.new
      levels[1] = file.cell(line,"G")
      levels[2] = file.cell(line,"H")
      levels[3] = file.cell(line,"I")
      levels[4] = file.cell(line,"J")
      levels.each {|level| level.strip! unless level.blank?}

      moment_tags = Array.new
      moment_tags[0] = @category_three_level0

      level_hierarchy = @main_category.id.to_s + ">>" + @category_three_level0.id.to_s

      if ( !levels[1].blank? or
           (!levels[1].blank? and !levels[2].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?)           
       ) and require_level_affinity == "affinity"

        pp require_level_affinity + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect

        1.upto(4) do |level|
          unless levels[level].blank?
            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
            if moment_tags[level].blank?
              if levels[level+1].blank?

                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :require_level_affinity => require_level_affinity,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
              else
                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )

              end
            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
              moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :require_level_affinity => require_level_affinity,
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
            end
            level_hierarchy += ">>" + moment_tags[level].id.to_s
          end
        end
      end
    end


    print "DONE\n"

    
    print "LearnerTagsSpreadsheet: Real World Interest areas......................................\n"

    file = Excel.new(@file_path)
    file.default_sheet = file.sheets.at(4)

    @main_category = MomentTag.create(:name => "A Place, Thing or Situation of Interest")
    @category_one_level0 = MomentTag.create(:name => "Real World Interest areas", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
    @index = 0

    2.upto(file.last_row) do |line|

      name = file.cell(line,'A')
      name.strip! unless name.blank?

      require_level_affinity  = file.cell(line,'B')
      unless require_level_affinity.blank?
        require_level_affinity = require_level_affinity.downcase
        require_level_affinity.strip!
      end

      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')

      parent_question = file.cell(line,"E")
      parent_question.strip! unless parent_question.blank?

      levels = Array.new
      levels[1] = file.cell(line,"G")
      levels[2] = file.cell(line,"H")
      levels[3] = file.cell(line,"I")
      levels[4] = file.cell(line,"J")
      levels[5] = file.cell(line,"K")
      levels[6] = file.cell(line,"L")
      levels[7] = file.cell(line,"M")
      levels.each {|level| level.strip! unless level.blank?}

      moment_tags = Array.new
      moment_tags[0] = @category_one_level0

      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s

      if ( !levels[1].blank? or
           (!levels[1].blank? and !levels[2].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank? and !levels[6].blank?) or
           (!levels[1].blank? and !levels[2].blank? and !levels[3].blank? and !levels[4].blank? and !levels[5].blank? and !levels[6].blank? and !levels[7].blank?)
       ) and require_level_affinity == "affinity"

        pp require_level_affinity.inspect + " :::: " + levels[1].inspect + " -> " + levels[2].inspect + " -> " + levels[3].inspect + " -> " + levels[4].inspect + " -> " + levels[5].inspect + " -> " + levels[6].inspect + " -> " + levels[7].inspect

        1.upto(7) do |level|
          unless levels[level].blank?
            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
            if moment_tags[level].blank?
              if levels[level+1].blank?

                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :require_level_affinity => require_level_affinity,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
              else
                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )

              end
            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
              moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :require_level_affinity => require_level_affinity,
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
            end
            level_hierarchy += ">>" + moment_tags[level].id.to_s
          end
        end
      end
    end


    print "DONE\n"
    
    print "LearnerTagsSpreadsheet: People/Relationships......................................\n"

    file = Excel.new(@file_path)
    file.default_sheet = file.sheets.at(5)

    @main_category = MomentTag.create(:name => "People/Relationships")
    @category_one_level0 = MomentTag.create(:name => "People Assets", :moment_tag_id => @main_category.id, :level => 0, :level_hierarchy => @main_category.id.to_s)
    @index = 0

    2.upto(file.last_row) do |line|

      name = file.cell(line,'A')
      name.strip! unless name.blank?

      require_level_affinity  = file.cell(line,'B')      
      unless require_level_affinity.blank?
        require_level_affinity = require_level_affinity.downcase
        require_level_affinity.strip!
      end

      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')

      parent_question = file.cell(line,"E")
      parent_question.strip! unless parent_question.blank?

      levels = Array.new
      levels[1] = file.cell(line,"F")
      levels[2] = file.cell(line,"G")      
      levels.each {|level| level.strip! unless level.blank?}

      moment_tags = Array.new
      moment_tags[0] = @category_one_level0

      level_hierarchy = @main_category.id.to_s + ">>" + @category_one_level0.id.to_s

      if ( !levels[1].blank? or
           (!levels[1].blank? and !levels[2].blank?)           
       ) #and require_level_affinity == "affinity"

        pp require_level_affinity.inspect + " :::: " + levels[1].inspect + " -> " + levels[2].inspect

        1.upto(2) do |level|
          unless levels[level].blank?
            moment_tags[level] = MomentTag.where(:name => levels[level], :level => level, :level_hierarchy => level_hierarchy).first
            if moment_tags[level].blank?
              if levels[level+1].blank?

                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :value_type => value_type,
                  :require_level_affinity => require_level_affinity,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
                
              else
                
                moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
                
              end
            elsif levels[level+1].blank? and moment_tags[level].parent_question != parent_question
              moment_tags[level] = MomentTag.create(
                  :name => levels[level],
                  :require_level_affinity => require_level_affinity,
                  :value_type => value_type,
                  :value_range => value_range,
                  :parent_question => parent_question,
                  :moment_tag_id => moment_tags[level-1].id,
                  :level => level,
                  :level_hierarchy => level_hierarchy
                )
            end
            level_hierarchy += ">>" + moment_tags[level].id.to_s
          end
        end
      end
    end


    print "DONE\n"

  end

  desc "Checking updated moments"
  task :checking => :environment do
#    @parent_name = "Growth and Development"
#    @parent_name = "Waves Properties"
    @parent_name = "State of Matter"
#    @parent_name = "Visual & Spatial Ordering"
#    @parent_name = "Basic Mental Processing"
#    @parent_name = "Develop Possible Solutions"
#    @parent_name = "Energy Production"
#    @parent_name = "Engineering, Technology, and Application of Science"


    @moment_tags = MomentTag.where(["moment_tag_id IS NULL"])

    pp "************************************"

    @moment_tags.each do |moment_tag|
      pp moment_tag.id.to_s + ":::" + moment_tag.require_level_affinity.to_s + ":::" + moment_tag.name.to_s + ":::" + moment_tag.parent_question.to_s + ":::" + moment_tag.level_hierarchy.to_s + ":::" + moment_tag.level.to_s
    end

    pp "************************************"
    pp "Children of \"" + @parent_name + "\""
    pp "************************************"

    @children_tags = @moment_tags.first.children_tags
    @children_tags.each do |child_tag|
      pp child_tag.id.to_s + ":::" + child_tag.require_level_affinity.to_s + ":::" + child_tag.name.to_s + ":::" + child_tag.value_type.to_s + ":::" + child_tag.parent_question.to_s + ":::" + child_tag.parent_tag.name + ":::" + child_tag.level_hierarchy.to_s + ":::" + child_tag.level.to_s
    end
  end


  desc "Migrating questions to database from excel file - 'ProfileQs.xls'"
  task :questions => :environment do
    
    print "------ migrating questions ------ \n"    
    Question.delete_all
    file = Excel.new('public/ProfileQs.xls')
    file.default_sheet = file.sheets.at(1)    
    2.upto(file.last_row) do |line|
      cat = file.cell(line,'C')
      mid = file.cell(line,'D')
      desc  = file.cell(line,'F')
      age = file.cell(line,'J')
      
      Question.create(:text => desc, :category => cat, :age => age, :mid => mid)
    end
    
  end

  desc "Migratinog milestones from excel file = 'Milestones_Sample'"
  task :milestones => :environment do
    pp "------ migrating milestones ------ "

    Milestone.delete_all
    file = Excel.new('public/Milestones_Sample.xls')
    file.default_sheet = file.sheets.at(0)
    2.upto(file.last_row) do |line|
      mid = file.cell(line, 'A')
      unless mid.blank?
        title = file.cell(line, 'B')
        research_background = file.cell(line, 'C')
        research_references = file.cell(line, 'D')
        observation_title = file.cell(line, 'E')
        observation_desc = file.cell(line, 'F')
        observation_what_it_means = file.cell(line, 'G')
        other_occurances = file.cell(line, 'H')
        parent_as_partner = file.cell(line, 'I')
        activity_1_title = file.cell(line, 'J')
        activity_1_subtitle = file.cell(line, 'K')
        activity_1_set_up = file.cell(line, 'L')
        activity_1_response = file.cell(line, 'M')
        activity_1_modification = file.cell(line, 'N')
        activity_1_later_developments = file.cell(line,'O')
        activity_1_learning_benefits = file.cell(line,'P')
        activity_2_title = file.cell(line,'Q')
        activity_2_subtitle = file.cell(line,'R')
        activity_2_situation = file.cell(line,'S')
        activity_2_response = file.cell(line,'T')
        activity_2_modification = file.cell(line,'U')
        activity_2_later_developments = file.cell(line,'V')
        activity_2_learning_benefits = file.cell(line,'W')

        pp "#{mid}: #{title}"

        milestone = Milestone.create(
                      :mid => mid,
                      :title => title,
                      :research_background => research_background,
                      :research_references => research_references,
                      :observation_title => observation_title,
                      :observation_desc => observation_desc,
                      :observation_what_it_means => observation_what_it_means,
                      :other_occurances => other_occurances,
                      :parent_as_partner => parent_as_partner,
                      :activity_1_title => activity_1_title,
                      :activity_1_subtitle => activity_1_subtitle,
                      :activity_1_set_up => activity_1_set_up,
                      :activity_1_response => activity_1_response,
                      :activity_1_modification => activity_1_modification,
                      :activity_1_later_developments => activity_1_later_developments,
                      :activity_1_learning_benefits => activity_1_learning_benefits,
                      :activity_2_title => activity_2_title,
                      :activity_2_subtitle => activity_2_subtitle,
                      :activity_2_situation => activity_2_situation,
                      :activity_2_response => activity_2_response,
                      :activity_2_modification => activity_2_modification,
                      :activity_2_later_developments => activity_2_later_developments,
                      :activity_2_learning_benefits => activity_2_learning_benefits
                    )          
      end
    end

    pp "------ DONE ------"
  end

  desc "Migrating the all excell documents to database"
  task :all do

    print "## Migrating all excel documents to database started!\n"

      Rake::Task['excel:moment_tags'].invoke
      Rake::Task['excel:questions'].invoke

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

end