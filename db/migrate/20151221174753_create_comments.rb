class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps null: false

      t.index [:commentable_id, :commentable_type]
    end
  end
end
