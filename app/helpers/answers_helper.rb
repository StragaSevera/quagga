module AnswersHelper
  def check_icon(answer)
    fa_icon "check 3x", id: "answer-check-#{answer.id}", class: check_class(answer)
  end

  def check_class(answer)
    if answer.best?
      "answer-check answer-best"
    else
      "answer-check answer-normal"
    end
  end
end
