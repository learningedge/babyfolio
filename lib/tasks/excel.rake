namespace :excel do
  
  desc "Migrating moment_tags to db from excel file"
  task :moment_tags => :environment do
    print "------ migrating moment_tags ------\n"

    MomentTag.delete_all

    print "LearnerTagsSpreadsheet: Competenses/Abilities.................................."

    @category_one_level0 = MomentTag.create(:name => "A Striking Developments (Reveals Insight into who your child is)")

    file = Excel.new('public/LearnerTagsSpreadsheet.xls')
    file.default_sheet = file.sheets.at(1)

    2.upto(file.last_row) do |line|      
      name = file.cell(line,'A')
      require_level_affinity  = file.cell(line,'B')
      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')
      parent_question = file.cell(line,"E")
      child_question = file.cell(line,'F')
      statement = file.cell(line,'G')
      level1 = file.cell(line,"H")
      level2 = file.cell(line,"I")
      level3 = file.cell(line,"J")
      level4 = file.cell(line,"K")
      level5 = file.cell(line,"M")
      level6 = file.cell(line,"N")

      unless (level1.blank? and level2.blank? and level3.blank? and level4.blank? and level5.blank? and level6.blank?)

        if level2.blank?
          moment_tag_id = @category_one_level0.id
        elsif level3.blank?
          moment_tag_id = @category_one_level1.id
        elsif level4.blank?
          moment_tag_id = @category_one_level2.id
        elsif level5.blank?
          moment_tag_id = @category_one_level3.id
        elsif level6.blank?
          moment_tag_id = @category_one_level4.id
        end

        tag = MomentTag.create(
                :name => name,
                :require_level_affinity => require_level_affinity,
                :value_type => value_type,
                :value_range => value_range,
                :parent_question => parent_question,
                :child_question => child_question,
                :statement => statement,
                :moment_tag_id => moment_tag_id
              )

        
         if level2.blank?
           @category_one_level1 = tag
         elsif level3.blank?
           @category_one_level2 = tag
         elsif level4.blank?
           @category_one_level3 = tag
         elsif level5.blank?
           @category_one_level4 = tag
         elsif level6.blank?
           @category_one_level5 = tag
         end
      
      
      end

    end

    print "DONE\n"

    print "LearnerTagsSpreadsheet: Concepts/Subjects......................................"

    file = Excel.new('public/LearnerTagsSpreadsheet.xls')
    file.default_sheet = file.sheets.at(2)

    2.upto(file.last_row) do |line|
      name = file.cell(line,'A')
      require_level_affinity  = file.cell(line,'B')
      value_type = file.cell(line,'C')
      value_range = file.cell(line,'D')
      parent_question = file.cell(line,"E")
      child_question = file.cell(line,'F')
      statement = file.cell(line,'G')
      level1 = file.cell(line,"H")
      level2 = file.cell(line,"I")
      level3 = file.cell(line,"J")
      level4 = file.cell(line,"K")
      level5 = file.cell(line,"M")      

      unless (level1.blank? and level2.blank? and level3.blank? and level4.blank? and level5.blank? and level6.blank?)

        if level2.blank?
          moment_tag_id = @category_one_level0.id
        elsif level3.blank?
          moment_tag_id = @category_one_level1.id
        elsif level4.blank?
          moment_tag_id = @category_one_level2.id
        elsif level5.blank?
          moment_tag_id = @category_one_level3.id
        elsif level6.blank?
          moment_tag_id = @category_one_level4.id
        end

        tag = MomentTag.create(
                :name => name,
                :require_level_affinity => require_level_affinity,
                :value_type => value_type,
                :value_range => value_range,
                :parent_question => parent_question,
                :child_question => child_question,
                :statement => statement,
                :moment_tag_id => moment_tag_id
              )


         if level2.blank?
           @category_one_level1 = tag
         elsif level3.blank?
           @category_one_level2 = tag
         elsif level4.blank?
           @category_one_level3 = tag
         elsif level5.blank?
           @category_one_level4 = tag
         elsif level6.blank?
           @category_one_level5 = tag
         end


      end

    end

    print "DONE\n"

  end


  desc "Migrating questions to database from excel file - 'ProfileQs.xls'"
  task :questions => :environment do
    
    print "------ migrating questions ------ \n"    
    Question.delete_all
    file = Excel.new('public/ProfileQs.xls')
    file.default_sheet = file.sheets.at(1)    
    2.upto(file.last_row) do |line|
      cat = file.cell(line,'C')
      desc  = file.cell(line,'F')
      age = file.cell(line,'J')
      Question.create(:text => desc, :category => cat, :age => age)
    end
    
  end

  desc "Migrating the all excell documents to database"
  task :all do

    print "## Migrating all excel documents to database started!\n"

      Rake::Task['excel:moment_tags'].invoke
      Rake::Task['excel:questions'].invoke

    print "## DONE!!!\n"
  end
  
end