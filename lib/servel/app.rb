class Servel::App
  def initialize(root)
    @root = Pathname.new(root)
    @file_server = Rack::File.new(root.to_s)
  end

  def call(env)
    url_root = env["SCRIPT_NAME"]
    url_path = clean_url_path(env["PATH_INFO"])

    return redirect("#{url_root}/") if env["PATH_INFO"] == ""

    fs_path = @root + url_path[1..-1]

    return @file_server.call(env) if fs_path.file?

    return redirect("#{url_root}#{url_path}/") unless env["PATH_INFO"].end_with?("/")

    index(Servel::Locals.new(url_root: url_root, url_path: url_path, fs_path: fs_path))
  end

  def redirect(location)
    [302, { "Location" => location }, []]
  end

  def clean_url_path(path)
    url_path = Rack::Utils.unescape_path(path)
    raise unless Rack::Utils.valid_path?(url_path)
    Rack::Utils.clean_path_info(url_path)
  end

  def index(locals)
    @haml_context ||= Servel::HamlContext.new
    body = @haml_context.render('index.haml', locals.resolve)

    [200, {}, [body]]
  end
end