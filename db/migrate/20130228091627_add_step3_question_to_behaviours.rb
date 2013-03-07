class AddStep3QuestionToBehaviours < ActiveRecord::Migration
  def change
    add_column :behaviours, :step3_question, :text

    Rake::Task['excel:load_all_data'].invoke
  end
end
