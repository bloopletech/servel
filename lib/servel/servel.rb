class Servel::Servel
  def initialize(path_map)
    @path_map = path_map
  end

  def start
    Rack::Handler::Puma.run(build_app)
  end

  def build_app
    url_map = {}

    @path_map.each_pair do |root, url_root|
      url_map[url_root] = Servel::App.new(root)
    end

    Rack::URLMap.new(url_map)
  end
end