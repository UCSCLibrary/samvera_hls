$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydra_hls/version"
require "engine_cart/rake_task"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydra_hls"
  s.version     = "0.0.1"
  s.authors     = ["Ned Henry, UCSC Library Digital Initiatives"]
  s.email       = ["ethenry@ucsc.edu"]
  s.homepage    = "http://github.com/UCSCLibrary/hydra_hls"
  s.summary     = "An engine to add hls adaptive streaming to a hydra based application."
  s.description = "This gem allows a hydra application to create hls derivative media files automatically after uploading audiovisual media files, and to display those to a user through hls adaptive streaming."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

end
