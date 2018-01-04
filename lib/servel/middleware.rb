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

    return @app.call(env) unless fs_path.directory?

    url_path << "/"

    return [302, { "Location" => url_path }, []] unless path == "" || path.end_with?("/")

    body = @haml_context.render('index.haml', Servel::Locals.new(url_path, fs_path).locals)
    [200, {}, [body]]
  end

  def url_path_for(url_path)
    url_path = Rack::Utils.unescape_path(url_path)
    raise unless Rack::Utils.valid_path?(url_path)

    Rack::Utils.clean_path_info(url_path)
  end
end