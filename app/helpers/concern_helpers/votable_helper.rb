module ConcernHelpers::VotableHelper
  def vote_url(answer, direction)
    vote_question_answer_url(id: answer.id, question_id: answer.question_id, direction: direction)
  end

  def direction_sign(direction)
    case direction.to_sym
    when :up
      ">"
    when :down
      "<"          
    end
  end

  def vote_link(answer, direction)
    link_to direction_sign(direction), vote_url(answer, direction), method: :patch, 
      id: "answer-score-vote-#{direction}-#{answer.id}", remote: true, 
      class: "answer-vote answer-vote-#{direction}", 
      data: { answer_id: answer.id }
  end
end
