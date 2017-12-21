class Servel::Middleware
  def initialize(app, options = {})
    @app = app
    @root = Pathname.new(options[:root])
    @haml_context = Servel::HamlContext.new
  end

  def call(env)
    path = env["PATH_INFO"]
    url_path = url_path_for(path)
    fs_path = @root + url_path[1..-1]

    unless fs_path.directory?
      return @app.call(env)
    end

    if path != "" && !path.end_with?("/")
      return [302, { "Location" => "#{url_path}/" }, []]
    end

    url_path << "/" if url_path != "" && !url_path.end_with?("/")

    klass = if env['QUERY_STRING'] == "gallery"
      Servel::GalleryView
    else
      Servel::IndexView
    end

    [200, {}, StringIO.new(klass.new(url_path, fs_path).render(@haml_context))]
  end

  def url_path_for(url_path)
    url_path = Rack::Utils.unescape_path(url_path)
    raise unless Rack::Utils.valid_path?(url_path)

    Rack::Utils.clean_path_info(url_path)
  end
end