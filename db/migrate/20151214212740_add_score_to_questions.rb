class AddScoreToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :score, :integer, default: 0
    add_index :questions, :score
  end
end
