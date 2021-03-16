class Servel::ConfigParser
  attr_reader :config

  def initialize
    @config = TTY::Config.new
    @config.filename = "servel"
    @config.append_path(Dir.pwd)
    @config.append_path((Pathname.new(Dir.home) + ".servel").to_s)
    @config.append_path(Dir.home)
    @config.env_prefix = "servel"
    @config.autoload_env
    @config.read if @config.exist?

    @config.append(*parse_argv, to: :listings)
    parse_binds
  end

  def parse_argv
    ARGV.map do |arg|
      root, url_root = arg.split(":" , 2)
      { root => url_root }
    end
  end

  def parse_binds
    return parse_ssl_bind if @config.fetch(:cert) && @config.fetch(:key)

    host = @config.fetch(:host)
    port = @config.fetch(:port)
    @config.set(:Host, value: host) if host
    @config.set(:Port, value: port) if port
  end

  def parse_ssl_bind
    host = @config.fetch(:host, default: ::Puma::ConfigDefault::DefaultTCPHost)
    port = @config.fetch(:port, default: ::Puma::ConfigDefault::DefaultTCPPort)
    key = Pathname.new(@config.fetch(:key)).expand_path
    cert = Pathname.new(@config.fetch(:cert)).expand_path

    query = URI.encode_www_form(key: key, cert: cert)
    @config.append("ssl://#{host}:#{port}?#{query}", to: :binds)
  end
end
