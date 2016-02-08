class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  def make_search
    authorize! :make_search, Search
    respond_with @result = Search.make_search(params[:query], params[:scope], params[:page])
  end
end
