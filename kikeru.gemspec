# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kikeru/version"

Gem::Specification.new do |spec|
  spec.name          = "kikeru"
  spec.version       = Kikeru::VERSION
  spec.authors       = ["Masafumi Yokoyama"]
  spec.email         = ["myokoym@gmail.com"]
  spec.summary       = %q{Keyboard Friendly Audio Player}
  spec.description   = %q{A keyboard friendly audio player by Ruby/GStreamer.}
  spec.homepage      = "https://github.com/myokoym/kikeru"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("gtk3")
  spec.add_runtime_dependency("gstreamer")

  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("test-unit-rr")
  spec.add_development_dependency("bundler", "~> 1.3")
  spec.add_development_dependency("rake")
end
