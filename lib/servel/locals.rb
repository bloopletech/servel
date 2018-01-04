class Servel::Locals
  def initialize(url_path, fs_path)
    @url_path = url_path
    @fs_path = fs_path
  end

  def locals
    directories, files = @fs_path.children.partition { |child| child.directory? }

    {
      url_path: @url_path,
      directories: sort_paths(directories),
      files: sort_paths(files)
    }
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end