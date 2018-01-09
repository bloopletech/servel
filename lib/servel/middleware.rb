class Servel::Middleware
  def initialize(app, options = {})
    @app = app
    @root = Pathname.new(options[:root])
    @url_root = options[:url_root] || "/"
    @file_server = Rack::File.new(@root.to_s)
  end

  def call(env)
    original_path = env["PATH_INFO"]
    sanitised_path = url_path_for(original_path)

    return redirect(@url_root) if "#{sanitised_path}/" == @url_root

    return @app.call(env) unless sanitised_path.start_with?(@url_root)

    url_path = sanitised_path.gsub(/\A#{Regexp.escape(@url_root)}/, '')
    fs_path = @root + url_path

    unless fs_path.directory?
      env["PATH_INFO"] = "/#{url_path}"
      return @file_server.call(env)
    end

    return redirect("#{@url_root}#{url_path}\/") unless original_path.end_with?("/")

    index(url_path, fs_path)
  end

  def redirect(location)
    [302, { "Location" => location }, []]
  end

  def url_path_for(path)
    url_path = Rack::Utils.unescape_path(path)
    raise unless Rack::Utils.valid_path?(url_path)

    url_path = Rack::Utils.clean_path_info(url_path)
    url_path << "/" if url_path != "/" && path.end_with?("/")

    url_path
  end

  def index(url_path, fs_path)
    @haml_context ||= Servel::HamlContext.new
    locals = Servel::Locals.new(url_root: @url_root, url_path: url_path, fs_path: fs_path).locals
    body = @haml_context.render('index.haml', locals)

    [200, {}, [body]]
  end
end