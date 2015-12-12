class AddScoreToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :score, :integer, default: 0
    add_index :answers, :score
  end
end
