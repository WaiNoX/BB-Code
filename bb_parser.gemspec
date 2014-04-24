$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "bb_parser"
  s.version = '0.0.2'
  s.authors = ["Michael Steinle"]
  s.email = ["aelnle@gmail.com"]
  s.homepage = "https://github.com/WaiNoX/BB-Code"
  s.summary = "bb_parser version 0.0.2"
  s.description = "Convert BBCode to HTML."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "Gemfile"]
  s.test_files = Dir["test/**/*"]
  
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
end