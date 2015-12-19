class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :votable_id
      t.string :votable_type
      t.integer :score, null: false

      t.timestamps null: false

      t.index [:votable_id, :votable_type]
    end
  end
end
