class SwitchBestAnswerRepresentation < ActiveRecord::Migration
  def change
    remove_column :questions, :best_answer_id, :integer
    add_column :answers, :best, :boolean, default: false, null: false
    add_index :answers, :best
  end
end
