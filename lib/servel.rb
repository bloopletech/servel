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
require 'digest'

module Servel
  def self.build_app(listings:, username: nil, password: nil)
    app = build_listings_app(build_path_map(listings))

    if username && username != ""
      build_authentication_app(app: app, username: username, password: password)
    else
      app
    end
  end

  def self.build_authentication_app(app:, username:, password:)
    hashed_username = Digest::SHA512.digest(username)
    hashed_password = Digest::SHA512.digest(password)

    Rack::Auth::Basic.new(app) do |submitted_username, submitted_password|
      hashed_submitted_username = Digest::SHA512.digest(submitted_username)
      hashed_submitted_password = Digest::SHA512.digest(submitted_password)

      Rack::Utils.secure_compare(
        "#{hashed_username}#{hashed_password}",
        "#{hashed_submitted_username}#{hashed_submitted_password}"
      )
    end
  end

  def self.build_path_map(listings)
    listings.map do |listing|
      listing = { listing => nil } if listing.is_a?(String)

      root, url_root = listing.keys.first, listing.values.first || "/"
      [Pathname.new(root).realpath, url_root]
    end.to_h
  end

  def self.build_listings_app(path_map)
    url_map = path_map.map { |root, url_root| [url_root, Servel::App.new(root)] }.to_h
    url_map["/"] = Servel::HomeApp.new(path_map.values) unless url_map.keys.include?("/")

    Rack::URLMap.new(url_map)
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
