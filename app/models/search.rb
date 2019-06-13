class Search < ApplicationRecord
  CATEGORIES = %w[Question Answer Comment User]

  def self.find(query, category)
    # Sphinx does have some reserved characters, so you may need to escape your query terms.
    escaped_query = ThinkingSphinx::Query.escape(query)
    if CATEGORIES.include?(category)
      resource = category.classify.constantize
      resource.search escaped_query
    else
      ThinkingSphinx.search escaped_query
    end
  end
end
