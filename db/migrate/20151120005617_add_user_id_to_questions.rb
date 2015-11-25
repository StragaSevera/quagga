class AddUserIdToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
