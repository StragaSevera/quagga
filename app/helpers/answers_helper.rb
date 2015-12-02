module AnswersHelper
  def best_check_icon(answer)
    fa_icon "check", id: "answer-best-check-#{answer.id}"
  end

  def best_status_class(answer)
    if answer.best?
      "answer-best-status answer-best"
    else
      "answer-best-status answer-normal"
    end
  end
end
