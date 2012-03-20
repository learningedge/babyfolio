# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth-vimeo}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benjamin Fritsch"]
  s.date = %q{2011-11-07}
  s.description = %q{OmniAuth strategy for Vimeo}
  s.email = ["ben@lomography.com"]
  s.files = [".gitignore", "README.md", "lib/omniauth-vimeo.rb", "lib/omniauth-vimeo/version.rb", "lib/omniauth/strategies/vimeo.rb", "omniauth-vimeo.gemspec"]
  s.homepage = %q{https://github.com/lomography/omniauth-vimeo}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{OmniAuth strategy for Vimeo}

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
