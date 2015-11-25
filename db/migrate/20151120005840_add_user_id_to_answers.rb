class AddUserIdToAnswers < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
