class Servel::Index
  extend Servel::Instrumentation
  RENDER_CACHE = LruRedux::ThreadSafeCache.new(100)

  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
  end

  def render
    RENDER_CACHE.getset(render_cache_key) { Servel::HamlContext.render('index.haml', locals) }
  end

  def render_cache_key
    @render_cache_key ||= [@fs_path.to_s, @fs_path.mtime.to_i].join("-")
  end

  def locals
    children = @fs_path.children.map { |path| Servel::EntryFactory.for(path) }.compact

    {
      url_root: @url_root,
      url_path: @url_path,
      special_entries: special_entries.to_json,
      directory_entries: children.select(&:directory?).to_json,
      file_entries: children.select(&:file?).to_json
    }
  end

  def special_entries
    list = []
    list << Servel::EntryFactory.home("/") if @url_root != ""

    unless @url_path == "/"
      list << Servel::EntryFactory.top(@url_root == "" ? "/" : @url_root)
      list << Servel::EntryFactory.parent("../")
    end

    list
  end

  instrument :render, :locals
end