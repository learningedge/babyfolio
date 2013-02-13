class AddHasAccessToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :access, :boolean, :default => true
  end
end
