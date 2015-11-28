module AnswersHelper
  def check_class(answer)
    if answer.best?
      "answer-check answer-best"
    else
      "answer-check answer-normal"
    end
  end
end
