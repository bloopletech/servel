
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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = "servel"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_dependency "rack", "~> 2.0"
  spec.add_dependency "puma"
  spec.add_dependency "hamlit"
  spec.add_dependency "activesupport"
  spec.add_dependency "lru_redux"
  spec.add_dependency "tty-config"
end
