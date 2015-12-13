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

  def vote_link(answer, direction)
    link_to(
      vote_question_answer_url(id: answer.id, question_id: answer.question_id, direction: direction), 
      method: :patch, id: "answer-score-vote-#{direction}-#{answer.id}", remote: true, 
      class: "answer-vote answer-vote-#{direction}", data: { answer_id: answer.id }
      ) do
          case direction.to_sym
          when :up
            ">"
          when :down
            "<"          
          end
        end
  end
end
