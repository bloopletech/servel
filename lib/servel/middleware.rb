class Servel::Middleware
  def initialize(app, options = {})
    @app = app
    @root = Pathname.new(options[:root])
    @file_server = Rack::File.new(@root.to_s)
  end

  def call(env)
    path = env["PATH_INFO"]
    url_path = url_path_for(path)
    fs_path = @root + url_path[1..-1]

    return @file_server.call(env) unless fs_path.directory?

    url_path << "/" unless url_path.end_with?("/")

    return [302, { "Location" => url_path }, []] unless path == "" || path.end_with?("/")

    index(url_path, fs_path)
  end

  def url_path_for(url_path)
    url_path = Rack::Utils.unescape_path(url_path)
    raise unless Rack::Utils.valid_path?(url_path)

    Rack::Utils.clean_path_info(url_path)
  end

  def index(url_path, fs_path)
    @haml_context ||= Servel::HamlContext.new
    locals = Servel::Locals.new(url_path: url_path, fs_path: fs_path, root: @root).locals
    body = @haml_context.render('index.haml', locals)

    [200, {}, [body]]
  end
end