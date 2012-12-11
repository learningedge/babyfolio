class AddVisibilityToMoments < ActiveRecord::Migration
  def change
    add_column :moments, :visibility, :string, :default => "public"
  end
end
