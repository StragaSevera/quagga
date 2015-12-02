class AddBestAnswerIdToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.references :best_answer, references: :answer, index: true
    end
  end
end
