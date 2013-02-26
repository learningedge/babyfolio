class AddFullNameToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :full_name, :string

    Family.all.each do |family|
      admin = family.admins.first
      if admin && admin.first_name.present?
        family.update_attribute(:full_name, "#{admin.first_name[0,1]}. #{family.name.capitalize}" )
      else
        family.update_attribute(:full_name, family.name)
      end
    end
  end
end
