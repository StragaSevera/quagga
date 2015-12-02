class AddForeignKeyBestAnswersToQuestion < ActiveRecord::Migration
  def change
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
