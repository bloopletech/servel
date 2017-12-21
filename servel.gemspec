
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "servel/version"

Gem::Specification.new do |spec|
  spec.name          = "servel"
  spec.version       = Servel::VERSION
  spec.authors       = ["Brenton \"B-Train\" Fletcher"]
  spec.email         = ["i@bloople.net"]

  spec.summary       = %q{Serves files and directories over HTTP.}
  spec.description   = %q{Serves files and directories over HTTP.}
  spec.homepage      = "http://bloople.net/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rack"
  spec.add_dependency "puma"
  spec.add_dependency "naturalsorter"
  spec.add_dependency "haml", "~> 4"
end
