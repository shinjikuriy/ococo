module PathRegex
  extend self

  TOP_LEVEL_ROUTES = %w[404.html 422.html 505.html]

  def root_namespace_path_regex
    Regexp.new(Regexp.union(top_level_routes).source, Regexp::IGNORECASE)
  end

  def top_level_routes
    TOP_LEVEL_ROUTES.push(PathParser.top_level_path).flatten.freeze
  end
end