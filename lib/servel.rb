require 'rack'
require 'rack/handler/puma'
require 'haml'
require 'naturalsorter'
require 'active_support/all'

require 'json'
require 'pathname'
require 'delegate'

module Servel
  def self.build_app(path_map)
    url_map = path_map.map { |root, url_root| [url_root, Servel::App.new(root)] }.to_h
    url_map["/"] = Servel::HomeApp.new(path_map.values) unless url_map.keys.include?("/")

    Rack::URLMap.new(url_map)
  end
end

require "servel/version"
require "servel/path"
require "servel/path_builder"
require "servel/haml_context"
require "servel/locals"
require "servel/app"
require "servel/home_app"
require "servel/cli"
