class Servel::CLI
  def initialize(argv)
    @argv = argv
  end

  def start
    Rack::Handler::Puma.run(Servel.build_app(path_map))
  end

  def path_map
    @argv.map do |arg|
      root, url_root = arg.split(":" , 2)
      root = Pathname.new(root).realpath

      [root, url_root || "/"]
    end.to_h
  end
end