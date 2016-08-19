class SearchQuery
  include ActiveAttr::Model
  SEARCH_CONDITIONS = %w(nil Questions Answers Comments Users)

  attribute :query
  attribute :condition
  validates :condition, inclusion: { in: SEARCH_CONDITIONS }


  def self.sphinx_search(query, condition)
    return [] unless SEARCH_CONDITIONS.include?(condition)
    escaped_query = Riddle::Query.escape(query)
    if condition == 'nil'
      ThinkingSphinx.search escaped_query
    else
      ThinkingSphinx.search escaped_query, classes: [condition.singularize.classify.constantize]
    end
  end
end
