class UpdateRelations < ActiveRecord::Migration
  def up
    relations = Relation.includes([[:child => :family], :user]).where('inviter_id IS NULL')

    relations.each do |relation|
      family = relation.user.families.find_by_name(relation.user.last_name)
      family = Family.create(:name => relation.user.last_name) unless family
      
      child = relation.child
      if child and child.family and child.family.nil?
        child.family = family
        child.save
      end
    end
  end

  def down
  end
end
