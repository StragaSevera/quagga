class Search
  SCOPES = %w(all question answer comment user)
  class << self
    def make_search(query, scope, page = 1)
      return unless SCOPES.include? scope
      scope_klass = scope == "all" ? nil : scope.classify.constantize
      ThinkingSphinx.search query, classes: [scope_klass], page: page
    end
  end
end