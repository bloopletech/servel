class Servel::App
  UTF_8 = Encoding::UTF_8
  SCRIPT_NAME = Rack::SCRIPT_NAME
  PATH_INFO = Rack::PATH_INFO

  def initialize(root)
    @root = Pathname.new(root)
    @file_server = Rack::File.new(root.to_s)
  end

  def call(env)
    env[SCRIPT_NAME] = try_encode(env[SCRIPT_NAME])
    env[PATH_INFO] = try_encode(env[PATH_INFO])

    url_root = env[SCRIPT_NAME]
    url_path = clean_url_path(env[PATH_INFO])

    return redirect("#{url_root}/") if env[PATH_INFO] == ""

    fs_path = @root + url_path[1..-1]

    return @file_server.call(env) if fs_path.file?

    return redirect("#{url_root}#{url_path}/") unless env[PATH_INFO].end_with?("/")

    return [404, {}, []] unless fs_path.exist?

    Servel::Index.new(url_root: url_root, url_path: url_path, fs_path: fs_path).render
  end

  def redirect(location)
    [302, { "Location" => Rack::Utils.escape_path(location) }, []]
  end

  def clean_url_path(path)
    url_path = Rack::Utils.unescape_path(path)
    raise unless Rack::Utils.valid_path?(url_path)
    Rack::Utils.clean_path_info(url_path)
  end

  def try_encode(string)
    return string if string.encoding == UTF_8
    string.encode(UTF_8)
  rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
    string
  end
end