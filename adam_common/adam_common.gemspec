# -*- encoding: utf-8 -*-
require File.expand_path('../lib/adam_common/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Langfeld"]
  gem.email         = ["ben@langfeld.me"]
  gem.description   = %q{Common functionality shared across Adam Snark Rabbit implementation}
  gem.summary       = %q{Adam Snark Rabbit shared components}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adam_common"
  gem.require_paths = ["lib"]
  gem.version       = AdamCommon::VERSION

  gem.add_runtime_dependency 'virtus'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
end
