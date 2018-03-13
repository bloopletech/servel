class Servel::Index
  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
  end

  def render
    Servel::HamlContext.render('index.haml', locals)
  end

  def locals
    {
      url_root: @url_root,
      url_path: @url_path,
      directories: directories,
      files: files
    }
  end

  def directories
    list = @fs_path.children.select { |child| child.directory? }
    list = sort_paths(list).map { |path| Servel::EntryFactory.for(path) }

    unless @url_path == "/"
      list.unshift(Servel::EntryFactory.parent("../"))
      list.unshift(Servel::EntryFactory.top(@url_root == "" ? "/" : @url_root))
    end

    list
  end

  def files
    list = @fs_path.children.select { |child| child.file? }
    sort_paths(list).map { |path| Servel::EntryFactory.for(path) }
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end