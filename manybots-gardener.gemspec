$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "manybots-gardener/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "manybots-gardener"
  s.version     = ManybotsGardener::VERSION
  s.authors     = ["Alexandre L. Solleiro"]
  s.email       = ["alex@webcracy.org"]
  s.homepage    = "https://www.manybots.com"
  s.summary     = "Get predictions and notifications on when to water your plants."
  s.description = "This Manybots Agent observes weather conditions on your Manybots account to decide wether you should water the plants."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "httparty"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
