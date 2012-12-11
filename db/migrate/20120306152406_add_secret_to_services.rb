class AddSecretToServices < ActiveRecord::Migration
  def change

    add_column :services, :secret, :string

  end
end
