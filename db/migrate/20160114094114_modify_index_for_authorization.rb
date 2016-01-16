class ModifyIndexForAuthorization < ActiveRecord::Migration
  def change
    remove_index :authorizations, [:provider, :uid]
    add_index :authorizations, [:provider, :uid, :activated]
  end
end
