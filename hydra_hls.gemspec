$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydra_hls/version"
require "engine_cart/rake_task"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydra_hls"
  s.version     = HydraHls::VERSION
  s.authors     = ["Ned Henry"]
  s.email       = ["ethenry@ucsc.edu"]
  s.homepage    = "http://github.com/UCSCLibrary/hydra_hls"
  s.summary     = "An engine to add hls adaptive streaming to a hydra based application."
  s.description = "This gem allows a hydra application to create hls derivative media files automatically after uploading audiovisual media files, and to display those to a user through hls adaptive streaming."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

#  s.add_development_dependency "sqlite3"

#from sufia
  s.add_development_dependency 'engine_cart', '~> 0.8'
#  s.add_development_dependency 'mida', '~> 0.3'
#  s.add_development_dependency 'database_cleaner', '~> 1.3'
#  s.add_development_dependency 'solr_wrapper', '~> 0.5'
#  s.add_development_dependency 'fcrepo_wrapper', '~> 0.5', '>= 0.5.1'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'rspec-its', '~> 1.1'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'poltergeist', "~> 1.5"
  s.add_development_dependency 'factory_girl_rails', '~> 4.4'
  s.add_development_dependency 'equivalent-xml', '~> 0.5'
  s.add_development_dependency 'jasmine', '~> 2.3'
  s.add_development_dependency 'rubocop', '~> 0.40.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.5'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
#  s.add_development_dependency 'rspec-rails'
# s.add_development_dependency 'capybara'
# s.add_development_dependency 'factory_girl_rails'


end
