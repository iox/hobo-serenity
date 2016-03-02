Gem::Specification.new do |s|
  s.name        = 'hobo-serenity'
  s.version     = '1.0'
  s.date        = '2016-01-15'
  s.summary     = "Connect Hobo app (hobocentral.net) with Serenity and Serenity-ODT gems"
  s.description = "You will be able to render ODT templates (and ODT based PDFs) from your Hobo app."
  s.authors     = ["Ignacio Huerta"]
  s.email       = 'ignacio@ihuerta.net'
  s.files       = ["lib/hobo-serenity.rb"]
  s.homepage    = 'https://github.com/iox/hobo-serenity'
  s.license     = 'MIT'
  s.add_dependency(%q<serenity-odt>, [">= 0.2.1"])
  s.add_dependency(%q<rubyzip>, ["0.9.9"])
end
