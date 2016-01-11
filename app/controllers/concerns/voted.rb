module Voted
  extend ActiveSupport::Concern
  include Introspected

  included do
    before_action :load_votable, only: [:vote] 
    helper ConcernHelpers::VotableHelper  
  end

  # Технически, можно "посадить на диету" и этот консерн,
  # только вот куда положить JBuilder-вьюху и стоит ли вообще переусложнять?..
  def vote
    if @votable.vote(params[:direction], current_user.id)
      render json: { score: @votable.score }
    else
      render json: { score: @votable.score }, status: :unprocessable_entity
    end
  end

  private
    def load_votable
      @votable = model_klass.find(params[:id])
    end
end