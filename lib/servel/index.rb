class Servel::Index
  extend Servel::Instrumentation
  LOCALS_CACHE = LruRedux::ThreadSafeCache.new(100)

  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
    @locals_cache_key = "#{@fs_path.mtime}-#{@fs_path.to_s}"
  end

  def render
    Servel::HamlContext.render('index.haml', locals)
  end

  def locals
    LOCALS_CACHE.getset(@locals_cache_key) { build_locals }
  end

  def build_locals
    entries = @fs_path.children.map { |path| Servel::EntryFactory.for(path) }

    {
      url_root: @url_root,
      url_path: @url_path,
      directories: directories(entries),
      files: files(entries)
    }
  end

  def directories(entries)
    list = sort_entries(entries.select { |entry| entry.directory? })

    unless @url_path == "/"
      list.unshift(Servel::EntryFactory.parent("../"))
      list.unshift(Servel::EntryFactory.top(@url_root == "" ? "/" : @url_root))
    end

    list.unshift(Servel::EntryFactory.home("/")) if @url_root != ""

    list
  end

  def files(entries)
    sort_entries(entries.select { |entry| entry.file? })
  end

  def sort_entries(entries)
    Naturalsorter::Sorter.sort_by_method(entries, :name, true)
  end

  instrument :locals, :directories, :files, :sort_entries
end