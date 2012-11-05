class AddIsAdminToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :is_admin, :boolean, :default => false
    Relation.all.each do |r|
      if r.member_type == 'parent' || r.member_type == 'father' || r.member_type == "mother"
        r.update_attribute(:is_admin, true)
      end
    end
  end
end
