module Voted
  extend ActiveSupport::Concern
  include Introspected

  included do
    before_action :load_votable, only: [:vote] 
    helper ConcernHelpers::VotableHelper  
  end

  def vote
    if @votable.vote(vote_params, current_user.id)
      render json: { score: @votable.score }
    else
      render json: { score: @votable.score }, status: :unprocessable_entity
    end
  end

  private
    def load_votable
      @votable = model_klass.find(params[:id])
    end

    def vote_params
      params.require(:direction)
    end
end