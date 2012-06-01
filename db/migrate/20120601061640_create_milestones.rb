class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones, :options => "ENGINE=MyISAM" do |milestone|

      milestone.integer :mid
      milestone.string :title
      milestone.text :research_background
      milestone.text :research_references
      milestone.string :observation_title
      milestone.text :observation_desc
      milestone.text :observation_what_it_means
      milestone.text :other_occurances
      milestone.text :parent_as_partner
      milestone.string :activity_1_title
      milestone.string :activity_1_subtitle
      milestone.text :activity_1_set_up
      milestone.text :activity_1_response
      milestone.text :activity_1_modification
      milestone.text :activity_1_later_developments
      milestone.text :activity_1_learning_benefits
      milestone.string :activity_2_title
      milestone.string :activity_2_subtitle
      milestone.text :activity_2_situation
      milestone.text :activity_2_response
      milestone.text :activity_2_modification
      milestone.text :activity_2_later_developments
      milestone.text :activity_2_learning_benefits

      milestone.timestamps
    end
  end
end
