class Servel::Locals
  def initialize(url_root:, url_path:, fs_path:)
    @url_root = url_root
    @url_path = url_path
    @fs_path = fs_path
  end

  def resolve
    {
      url_root: @url_root,
      url_path: @url_path,
      directories: directories,
      files: files
    }
  end

  def directories
    list = @fs_path.children.select { |child| child.directory? }
    list = sort_paths(list).map { |path| build(path) }

    unless @url_path == "/"
      list.unshift(Servel::Path.parent("../"))
      list.unshift(Servel::Path.top(@url_root))
    end

    list
  end

  def build(path)
    Servel::PathBuilder.new(path).build
  end

  def files
    list = @fs_path.children.select { |child| child.file? }
    sort_paths(list).map { |path| build(path) }
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end