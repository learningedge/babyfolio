class AddZipToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :zip_code, :string, :limit => 10
  end
end
