class UpdateRelationsAcceptedColumnToInteger < ActiveRecord::Migration
  def up
    add_column :relations, :accepted_2, :integer
    execute("update relations set accepted_2 = (CASE WHEN accepted THEN 1 ELSE 0 END)");
    remove_column :relations, :accepted
    rename_column :relations, :accepted_2, :accepted
  end

  def down
    add_column :relations, :accepted_2, :boolean
    execute("update relations set accepted_2 = (CASE WHEN accepted == 1 THEN true ELSE false END)");
    remove_column :relations, :accepted
    rename_column :relations, :accepted_2, :accepted
  end
end
