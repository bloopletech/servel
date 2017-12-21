class Servel::Servel
  def initialize(server_root)
    @server_root = server_root
  end
  
  def start
    Rack::Handler::Puma.run(build_app)
  end
  
  def build_app
    server_root = @server_root

    Rack::Builder.new do
      use(Servel::Middleware, root: server_root)
      use Rack::Static, urls: [""], root: server_root.to_s

      run ->(env) do
        [404, {}, []]
      end
    end
  end
end