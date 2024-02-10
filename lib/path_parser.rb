module PathParser
  extend self

  INITIAL_SEGMENT_REGEX = %r{^\/([^\/\(:]+)}.freeze

  def top_level_path
    routes = Rails.application.routes.routes
    routes.collect { |r| match_initial_path(r.path.spec.to_s) }.compact.uniq
  end

  def match_initial_path(path)
    matchdata = INITIAL_SEGMENT_REGEX.match(path)
    matchdata[1] if matchdata
  end
end
