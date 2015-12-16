module QuestionsHelper
  def question_edit_class
    if params[:edit] == "1"
      ""
    else
      "block-hidden"
    end
  end
end
