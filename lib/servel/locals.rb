class Servel::Locals
  def initialize(url_path:, fs_path:, root:)
    @url_path = url_path
    @fs_path = fs_path
    @root = root
  end

  def locals
    {
      url_path: @url_path,
      directories: directories,
      files: files
    }
  end

  def directories
    list = @fs_path.children.select { |child| child.directory? }
    list = sort_paths(list)
    list.unshift(@fs_path.decorate(true)) unless @fs_path == @root
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