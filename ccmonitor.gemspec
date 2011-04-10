# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ccmonitor/version"

Gem::Specification.new do |s|
  s.name        = "ccmonitor"
  s.version     = Ccmonitor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan Ibiapina"]
  s.email       = ["juanibiapina@thoughtworks.com"]
  s.homepage    = ""
  s.summary     = %q{Build monitor}
  s.description = %q{Build monitor}

  s.rubyforge_project = "ccmonitor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
