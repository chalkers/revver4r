# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Revver4R}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Chalkley"]
  s.date = %q{2008-11-20}
  s.description = %q{A simple Ruby interface for Revver's api.}
  s.email = %q{andrew@chalkely.org}
  s.extra_rdoc_files = ["lib/revver4r.rb", "README.rdoc"]
  s.files = ["lib/revver4r.rb", "Rakefile", "README.rdoc", "Manifest", "Revver4R.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/chalkers/revver4r}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Revver4R", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{revver4r}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple Ruby interface for Revver's api.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
