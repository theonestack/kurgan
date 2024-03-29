
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kurgan/version"

Gem::Specification.new do |spec|
  spec.name          = "kurgan"
  spec.version       = Kurgan::VERSION
  spec.authors       = ["Guslington"]
  spec.email         = ["theonestackcfhighlander@gmail.com"]

  spec.summary       = %q{Manage a cfhighalnder project}
  spec.description   = %q{Manage a cfhighalnder project}
  spec.homepage      = "http://iamkurgan.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "terminal-table", '~> 1', '<2'
  spec.add_dependency "faraday", '~> 1', '<2'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
