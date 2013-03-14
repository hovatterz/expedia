# -*- encoding: utf-8 -*-
require File.expand_path('../lib/expedia/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Zack Hovatter"]
  gem.email         = ["zackhovatter@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "expedia"
  gem.require_paths = ["lib"]
  gem.version       = Expedia::VERSION

  gem.add_development_dependency "rake", "~> 10.0.3"
  gem.add_development_dependency "webmock", "~> 1.8.0"
  gem.add_development_dependency "vcr", "~> 2.3.0"
  gem.add_runtime_dependency "activesupport", "~> 3.2.1"
  gem.add_runtime_dependency "httparty", "~> 0.9.0"
  gem.add_runtime_dependency "json", "~> 1.7.7"
end
