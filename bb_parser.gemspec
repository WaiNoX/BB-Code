$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "bb_parser"
  s.version = '0.0.1'
  s.authors = ["Michael Steinle"]
  s.email = ["aelnle@gmail.com"]
  s.homepage = "https://github.com/WaiNoX/BB-Code"
  s.summary = s.name + " " + s.version
  s.description = "Convert BBCode to HTML."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "Gemfile"]
  s.test_files = Dir["test/**/*"]
  
  s.add_dependency 'activesupport'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
end