require 'rack'
require 'rack/handler/puma'
require 'puma/configuration'
require 'hamlit'
require 'active_support/all'
require 'lru_redux'
require 'tty-config'

require 'thread'
require 'pathname'
require 'json'

module Servel
  def self.build_app(path_map)
    url_map = path_map.map { |root, url_root| [url_root, Servel::App.new(root)] }.to_h
    url_map["/"] = Servel::HomeApp.new(path_map.values) unless url_map.keys.include?("/")

    Rack::URLMap.new(url_map)
  end

  def self.config
    @config ||= Servel::ConfigParser.new.config
  end
end

require "servel/version"
require "servel/instrumentation"
require "servel/entry"
require "servel/entry_factory"
require "servel/haml_context"
require "servel/index"
require "servel/app"
require "servel/home_app"
require "servel/config_parser"
require "servel/cli"
