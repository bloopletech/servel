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
      use(Rack::Static, urls: [""], root: root.to_s)

      run ->(env) do
        [404, {}, []]
      end
    end
  end
end