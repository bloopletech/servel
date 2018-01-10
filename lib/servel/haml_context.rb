class Servel::HamlContext
  include ActiveSupport::NumberHelper

  ENGINE_OPTIONS = { remove_whitespace: true, escape_html: true, ugly: true }

  def initialize()
    @build_path = Pathname.new(__FILE__).dirname.realpath + 'templates'
    @haml_engine_cache = {}
  end

  def render(template, locals = {})
    haml_engine(template).render(self, locals)
  end

  def partial(name, locals = {})
    render("_#{name}.haml", locals)
  end

  def include(path)
    (@build_path + path).read
  end

  def decorate(path)
    Servel::PathnameDecorator.new(pathname: path)
  end

  def haml_engine(path)
    unless @haml_engine_cache.key?(path)
      @haml_engine_cache[path] = Haml::Engine.new(include(path), ENGINE_OPTIONS.merge(filename: path))
    end
    @haml_engine_cache[path]
  end
end