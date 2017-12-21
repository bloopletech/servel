class Servitude::IndexView
  def initialize(url_path, fs_path)
    @url_path = url_path
    @fs_path = fs_path
  end

  def render(haml_context)
    haml_context.render('index.haml', locals)
  end

  def locals
    directories, files = @fs_path.children.partition { |child| child.directory? }

    {
      url_path: @url_path,
      fs_path: @fs_path,
      directories: sort_paths(directories),
      files: sort_paths(files),
      show_gallery: files.any? { |file| file.image? }
    }
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end