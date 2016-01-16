class AddNameActivationDigestToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :name, :string
    add_column :authorizations, :activation_digest, :string
  end
end
