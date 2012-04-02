require 'roo'
class Question < ActiveRecord::Base

  def self.update_from_file(file_path)
    file = Excel.new(file_path)
    file.default_sheet = file.sheets.at(1)
    @array = Array.new
    2.upto(file.last_row) do |line|
      cat = file.cell(line,'C')
      desc  = file.cell(line,'F')
      age = file.cell(line,'J')
      @array << Question.create(:text => desc, :category => cat, :age => age)      
    end
    return @array
  end
end
