class Servel::HamlContext
  extend Servel::Instrumentation
  include ActiveSupport::NumberHelper

  LOCK = Mutex.new

  def self.render(template, locals)
    [200, {}, [new.render(template, locals)]]
  end

  def initialize
    @build_path = Pathname.new(__FILE__).dirname.realpath + 'templates'
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

  def sort_attrs(sort, current_method)
    data = { sort_method: current_method, sort_direction: "asc" }
    classes = ["sortable"]
    if sort[:method] == current_method
      data[:sort_active] = true
      data[:sort_direction] = sort[:direction]
      classes << "sort-active"
      classes << "sort-#{sort[:direction]}"
    end

    {
      data: data,
      class: classes
    }
  end

  def haml_engine(path)
    LOCK.synchronize do
      @@haml_engine_cache ||= {}
      unless @@haml_engine_cache.key?(path)
        @@haml_engine_cache[path] = Hamlit::Template.new(filename: path) { include(path) }
      end
      @@haml_engine_cache[path]
    end
  end

  instrument :render, :partial, :include
end