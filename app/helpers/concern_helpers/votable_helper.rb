module ConcernHelpers::VotableHelper
  DIRECTION = {up: '>', down: '<'}
  def direction_sign(direction)
    DIRECTION[direction.to_sym]
  end

  def votable_url(direction, poly_list)
    polymorphic_url([:vote, *poly_list], direction: direction)
  end

  def vote_link(votable, direction, poly_list)
    k_name = klass_name(votable)
    link_to direction_sign(direction), votable_url(direction, poly_list), method: :patch, 
      id: "#{k_name}-score-vote-#{direction}-#{votable.id}", remote: true, 
      class: "vote-link #{k_name}-vote-link #{k_name}-vote-#{direction}", 
      data: { "#{k_name}_id".to_sym => votable.id }
  end
end
