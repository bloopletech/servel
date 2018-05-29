class Servel::Index
  extend Servel::Instrumentation
  RENDER_CACHE = LruRedux::ThreadSafeCache.new(100)
  SORT_METHODS = ["name", "mtime", "size", "type"]
  SORT_DIRECTIONS = ["asc", "desc"]

  def initialize(url_root:, url_path:, fs_path:, params:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
    @params = params
  end

  def render
    RENDER_CACHE.getset(render_cache_key) { Servel::HamlContext.render('index.haml', locals) }
  end

  def render_cache_key
    @render_cache_key ||= [@fs_path.to_s, @fs_path.mtime.to_i, sort_method, sort_direction].join("-")
  end

  def locals
    entries = @fs_path.children.map { |path| Servel::EntryFactory.for(path) }.compact

    {
      url_root: @url_root,
      url_path: @url_path,
      directories: directories(entries),
      files: files(entries),
      sort: {
        method: sort_method,
        direction: sort_direction
      }
    }
  end

  def sort_method
    param = @params["_servel_sort_method"]
    param = "name" unless SORT_METHODS.include?(param)
    param
  end

  def sort_direction
    param = @params["_servel_sort_direction"]
    param = "asc" unless SORT_DIRECTIONS.include?(param)
    param
  end

  def directories(entries)
    list = apply_sort(entries.select { |entry| entry.directory? })

    unless @url_path == "/"
      list.unshift(Servel::EntryFactory.parent("../"))
      list.unshift(Servel::EntryFactory.top(@url_root == "" ? "/" : @url_root))
    end

    list.unshift(Servel::EntryFactory.home("/")) if @url_root != ""

    list
  end

  def files(entries)
    apply_sort(entries.select { |entry| entry.file? })
  end

  def apply_sort(entries)
    entries = case sort_method
    when "name"
      Naturalsorter::Sorter.sort_by_method(entries, :name, true)
    when "mtime"
      entries.sort_by { |entry| entry.mtime }
    when "size"
      entries.sort_by { |entry| entry.size || 0 }
    when "type"
      entries.sort_by { |entry| entry.type }
    end

    entries.reverse! if sort_direction == "desc"
    entries
  end

  instrument :render, :locals, :directories, :files, :apply_sort
end