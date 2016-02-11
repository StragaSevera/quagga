# Так как это юнит-тест, то...
require "./app/services/search"

RSpec.describe Search do
  context ".make_search" do
    it "returns nil if invalid scope" do
      expect(Search.make_search("123", "not_exist")).to be_nil
    end

    %w(question answer comment user).each do |scope|
      it "calls Sphinx with scope #{scope}" do
        expect(ThinkingSphinx).to receive(:search).with("123", classes: [scope.classify.constantize], page: 1)
        Search.make_search("123", scope)
      end
    end

    it "calls Sphinx without scope" do
      expect(ThinkingSphinx).to receive(:search).with("123", classes: [nil], page: 2)
      Search.make_search("123", "all", 2)
    end

    it "escapes query" do
      expect(Riddle::Query).to receive(:escape).with("123")
      Search.make_search("123", "all", 2)
    end
  end
end