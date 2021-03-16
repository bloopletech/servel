class Servel::CLI
  ALLOWED_PUMA_OPTIONS = [
    :Host,
    :Port,
    :binds
  ]

  def start
    Rack::Handler::Puma.run(Servel.build_app(path_map), **puma_options)
  end

  def path_map
    Servel.config.fetch(:listings).map do |listing|
      listing = { listing => nil } if listing.is_a?(String)

      root, url_root = listing.keys.first, listing.values.first || "/"
      [Pathname.new(root).realpath, url_root]
    end.to_h
  end

  def puma_options
    Servel.config.to_h.transform_keys(&:to_sym).slice(*ALLOWED_PUMA_OPTIONS)
  end
end
