require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "get #make_search" do
    it "calls Search" do
      expect(Search).to receive(:make_search).with("123", "all", "2")
      get :make_search, query: "123", scope: "all", page: "2"
    end
  end
end
