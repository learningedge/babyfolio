# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flickraw}
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mael Clerambault"]
  s.date = %q{2011-12-04}
  s.email = %q{maelclerambault@yahoo.fr}
  s.files = ["examples/auth.rb", "examples/interestingness.rb", "examples/search.rb", "examples/sinatra.rb", "examples/upload.rb", "test/test_upload.rb", "test/test.rb", "test/helper.rb", "lib/flickraw.rb", "lib/flickraw/oauth.rb", "lib/flickraw/response.rb", "lib/flickraw/request.rb", "lib/flickraw/api.rb", "flickraw_rdoc.rb", "LICENSE", "README.rdoc", "rakefile"]
  s.homepage = %q{http://hanklords.github.com/flickraw/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Flickr library with a syntax close to the syntax described on http://www.flickr.com/services/api}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
