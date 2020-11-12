class Servel::CLI
  def start
    Rack::Handler::Puma.run(Servel.build_app(path_map), {
      Host: Servel.config.fetch(:host),
      Port: Servel.config.fetch(:port)
    })
  end

  def path_map
    Servel.config.fetch(:listings).map do |listing|
      listing = { listing => nil } if listing.is_a?(String)

      root, url_root = listing.keys.first, listing.values.first || "/"
      [Pathname.new(root).realpath, url_root]
    end.to_h
  end
end
