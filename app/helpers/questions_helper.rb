module QuestionsHelper
  # Не люблю передавать nil-ы наружу, поэтому обрабатываю оба пути
  def question_edit_class
    if params[:edit] == "1"
      ""
    else
      "block-hidden"
    end
  end
end
