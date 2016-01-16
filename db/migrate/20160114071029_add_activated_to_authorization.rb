class AddActivatedToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :activated, :boolean, default: true
  end
end
