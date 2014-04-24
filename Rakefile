# 
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
 

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/testtask'
require 'rspec/core/rake_task'

$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "BB-Code"
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

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "BBCode Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/erector/*_spec.rb'
  spec.rspec_opts = [Dir["lib"].to_a.join(':')]
end
