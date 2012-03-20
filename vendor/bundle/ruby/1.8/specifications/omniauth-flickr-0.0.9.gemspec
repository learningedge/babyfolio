# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth-flickr}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Breitkreutz"]
  s.date = %q{2011-12-08}
  s.description = %q{OmniAuth strategy for Flickr}
  s.email = ["tim@sbrew.com"]
  s.files = [".gitignore", "Gemfile", "LICENSE", "README.md", "Rakefile", "TODO", "lib/omniauth-flickr.rb", "lib/omniauth-flickr/version.rb", "lib/omniauth/strategies/flickr.rb", "omniauth-flickr.gemspec"]
  s.homepage = %q{https://github.com/timbreitkreutz/omniauth-flickr}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{omniauth-flickr}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{OmniAuth strategy for Flickr}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth-oauth>, ["~> 1.0"])
    else
      s.add_dependency(%q<omniauth-oauth>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<omniauth-oauth>, ["~> 1.0"])
  end
end
