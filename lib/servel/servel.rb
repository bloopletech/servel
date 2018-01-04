class Servel::Servel
  def initialize(root)
    @root = root
  end

  def start
    Rack::Handler::Puma.run(build_app)
  end

  def build_app
    root = @root

    Rack::Builder.new do
      use(Servel::Middleware, root: root)

      run ->(env) do
        [404, {}, []]
      end
    end
  end
end