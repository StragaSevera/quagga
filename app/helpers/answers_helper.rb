module AnswersHelper
  def best_check_icon(answer, style = "")
    fa_icon "check", id: "answer-best-check-#{answer.id}", class: style
  end

  def best_status_class(answer)
    if answer.best?
      "answer-best-status answer-best"
    else
      "answer-best-status answer-normal"
    end
  end
end
