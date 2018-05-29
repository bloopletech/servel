class Servel::Index
  extend Servel::Instrumentation

  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
  end

  def render
    Servel::HamlContext.render('index.haml', locals)
  end

  def locals
    @entries = @fs_path.children.map { |path| Servel::EntryFactory.for(path) }

    {
      url_root: @url_root,
      url_path: @url_path,
      directories: directories,
      files: files
    }
  end

  def directories
    list = sort_entries(@entries.select { |entry| entry.directory? })

    unless @url_path == "/"
      list.unshift(Servel::EntryFactory.parent("../"))
      list.unshift(Servel::EntryFactory.top(@url_root == "" ? "/" : @url_root))
    end

    list.unshift(Servel::EntryFactory.home("/")) if @url_root != ""

    list
  end

  def files
    sort_entries(@entries.select { |entry| entry.file? })
  end

  def sort_entries(entries)
    Naturalsorter::Sorter.sort_by_method(entries, :name, true)
  end

  instrument :locals, :directories, :files, :sort_entries
end