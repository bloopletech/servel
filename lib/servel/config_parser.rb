class Servel::ConfigParser
  attr_reader :config

  def initialize
    @tty_config = TTY::Config.new
    @tty_config.filename = "servel"
    @tty_config.append_path(Dir.pwd)
    @tty_config.append_path((Pathname.new(Dir.home) + ".servel").to_s)
    @tty_config.append_path(Dir.home)
    @tty_config.env_prefix = "servel"
    @tty_config.autoload_env
    @tty_config.read if @tty_config.exist?

    @tty_config.append(*parse_argv, to: :listings)
    parse_binds

    @config = @tty_config.to_h.transform_keys(&:to_sym)
  end

  def parse_argv
    ARGV.map do |arg|
      root, url_root = arg.split(":" , 2)
      { root => url_root }
    end
  end

  def parse_binds
    return parse_ssl_bind if @tty_config.fetch(:cert) && @tty_config.fetch(:key)

    host = @tty_config.fetch(:host)
    port = @tty_config.fetch(:port)
    @tty_config.set(:Host, value: host) if host
    @tty_config.set(:Port, value: port) if port
  end

  def parse_ssl_bind
    host = @tty_config.fetch(:host, default: ::Puma::ConfigDefault::DefaultTCPHost)
    port = @tty_config.fetch(:port, default: ::Puma::ConfigDefault::DefaultTCPPort)
    key = Pathname.new(@tty_config.fetch(:key)).expand_path
    cert = Pathname.new(@tty_config.fetch(:cert)).expand_path

    query = URI.encode_www_form(key: key, cert: cert)
    @tty_config.append("ssl://#{host}:#{port}?#{query}", to: :binds)
  end
end
