class AddTokenToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :token, :string
    add_column :relations, :accepted, :boolean, :default => false
  end
end
