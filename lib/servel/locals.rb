class Servel::Locals
  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
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
    list = sort_paths(list)

    unless @url_path == ""
      list.unshift(Pathname.new("../").decorate(parent: true))
      list.unshift(Pathname.new(@url_root).decorate(top: true))
    end

    list
  end

  def files
    list = @fs_path.children.select { |child| child.file? }
    sort_paths(list)
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end