# -*- encoding: utf-8 -*-
require File.expand_path('../lib/datafix/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Case Commons, LLC"]
  gem.email         = ["casecommons-dev@googlegroups.com"]
  gem.description   = %q{Datafix provides a generator for documenting and testing database hotfixes}
  gem.summary       = %q{Datafix provides a generator for documenting and testing database hotfixes}
  gem.homepage      = "https://github.com/Casecommons/data_fix"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "datafix"
  gem.require_paths = ["lib"]
  gem.version       = Datafix::VERSION
end
