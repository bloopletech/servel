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
  end

  def parse_argv
    ARGV.map do |arg|
      root, url_root = arg.split(":" , 2)
      { root => url_root }
    end
  end
end
