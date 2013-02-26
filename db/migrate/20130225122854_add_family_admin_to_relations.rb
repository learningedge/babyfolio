class AddFamilyAdminToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :is_family_admin, :boolean
  end
end
