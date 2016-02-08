# Так как это юнит-тест, то...
require "./app/services/search"

RSpec.describe Search do
  context ".make_search" do
    it "returns nil if invalid scope" do
      expect(Search.make_search("123", "not_exist")).to be_nil
    end

    it "calls Sphinx with scope" do
      expect(ThinkingSphinx).to receive(:search).with("123", classes: [Question], page: 1)
      Search.make_search("123", "question")
    end

    it "calls Sphinx without scope" do
      expect(ThinkingSphinx).to receive(:search).with("123", classes: [nil], page: 2)
      Search.make_search("123", "all", 2)
    end
  end
end