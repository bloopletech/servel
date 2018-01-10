class Servel::Servel
  def initialize(mapping)
    @mapping = mapping
  end

  def start
    Rack::Handler::Puma.run(build_app)
  end

  def build_app
    mapping = @mapping

    Rack::Builder.new do
      mapping.each_pair do |root, url_root|
        use(Servel::Middleware, root: root, url_root: url_root)
      end

      run ->(env) do
        [404, {}, []]
      end
    end
  end
end