namespace :excel do


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

  task :load_all_data => :environment do
    update_db('app/assets/bf_complete.xls')
  end

private
  def update_db file_path
    file = Excel.new(file_path)
    file.sheets.each_with_index do |sh, idx|
      file.default_sheet = file.sheets.at(idx)
      print "\n\n#{sh}\n"
      if sh.downcase.include? "watch"        
        2.upto(file.last_row) do |line|
          if file.cell(line, 'A').blank?
            next
          end
          
          age = file.cell(line, 'B')
          if age.is_a? String
            age = age.split('-')
          else
            age = [age, age]
          end
          attr = {
            :uid => file.cell(line, 'A'),
            :age_from => age[0].to_i,
            :age_to => age[1].to_i,
            :category => file.cell(line, 'C').scan( /\(([A-Z]+)\)/).first.first,
            :learning_window => file.cell(line, 'D').scan( /LW([1-9])/).first.first,
            :expressive_interpretive => file.cell(line, 'E').scan( /\(([I|E])\)/).first.first,
            :title_present => file.cell(line, 'F'),
            :title_past => file.cell(line, 'G'),
            :step3_question => file.cell(line, 'H'),
            :description_short => file.cell(line, 'I'),
            :description_long => file.cell(line, 'J'),
            :example1 => file.cell(line, 'K'),
            :example2 => file.cell(line, 'L'),
            :example3 => file.cell(line, 'M'),
            :why_important => file.cell(line, 'N'),
            :theory => file.cell(line, 'O'),
            :references => file.cell(line, 'P'),
            :parenting_tip1 => file.cell(line, 'Q'),
            :parenting_tip2 => file.cell(line, 'R'),
            :page => file.cell(line, 'S').to_i,
            :background_research_theory => file.cell(line, 'T')
          }

          b = Behaviour.includes(:activities).find_or_initialize_by_uid(attr[:uid])
          b.update_attributes(attr)
          print "#{b.uid} => #{b.category} => age: #{b.age_from} => lw: #{b.learning_window} || #{ b.activities.size } acctivities \n"
        end
      elsif sh.downcase.include? "play"
        2.upto(file.last_row) do |line|
          if file.cell(line, 'A').blank?
            next
          end
          age = file.cell(line, 'B')
          if age.is_a? String
            age = age.split('-')
          else
            age = [age, age]
          end
          expr_inter = file.cell(line, 'E')
          expr_inter = expr_inter.scan( /\(([I|E])\)/).first.first if expr_inter.present?
          attr = {
            :uid => file.cell(line, 'A'),
            :age_from => age[0].to_i,
            :age_to => age[1].to_i,
            :category => file.cell(line, 'C').scan( /\(([A-Z]+)\)/).first.first,
            :activity_uid => file.cell(line, 'D'),
            :expressive_interpretive => expr_inter,
            :title => file.cell(line, 'F'),
            :action => file.cell(line, 'G'),
            :actioned => file.cell(line, 'H'),
            :description_short => file.cell(line, 'I'),
            :description_long => file.cell(line, 'J'),            
            :variation1 => file.cell(line, 'K'),
            :variation2 => file.cell(line, 'L'),
            :variation3 => file.cell(line, 'M'),
            :learning_benefit => file.cell(line, 'N'),
            :page => file.cell(line, 'O').to_i,
            :note => file.cell(line, 'P'),
            :real_world_interests => file.cell(line, 'Q')
          }

          a = Activity.find_or_initialize_by_activity_uid(attr[:activity_uid])
          a.update_attributes(attr)
          #a.load
          b = a.behaviour
          print "#{a.activity_uid} => #{a.category} => #{a.age_from} => #{ b.present? ? "match" : "NO BEHAVIOUR MATCH"}\n" #+ b.uid ? "-got behaviour-" : "-empty-"
        end
      end
    end
  end

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