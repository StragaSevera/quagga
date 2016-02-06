module QuestionsHelper
  def question_edit_class
    if params[:edit] == "1"
      ""
    else
      "block-hidden"
    end
  end

  def subscription_text(question)
    if current_user.subscribed?(question)
      "отписаться от вопроса"
    else
      "подписаться на вопрос"
    end
  end
end
