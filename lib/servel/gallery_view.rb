class Servel::GalleryView
  def initialize(url_path, fs_path)
    @url_path = url_path
    @fs_path = fs_path
  end

  def render(haml_context)
    haml_context.render('gallery.haml', locals)
  end

  def locals
    image_paths = @fs_path.children.select { |child| child.image? }

    {
      url_path: @url_path,
      fs_path: @fs_path,
      image_paths: sort_paths(image_paths)
    }
  end

  def sort_paths(paths)
    Naturalsorter::Sorter.sort(paths.map(&:to_s), true).map { |path| Pathname.new(path) }
  end
end