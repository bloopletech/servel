class Servel::CLI
  ALLOWED_PUMA_OPTIONS = [
    :Host,
    :Port,
    :binds
  ]

  def initialize
    @config = Servel::ConfigParser.new.config
  end

  def start
    app = Servel.build_app(**@config.slice(:listings, :username, :password))
    Rack::Handler::Puma.run(app, **@config.slice(*ALLOWED_PUMA_OPTIONS))
  end
end
