$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "web-debug-toolbar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "web-debug-toolbar"
  s.version     = WebDebugToolbar::VERSION
  s.authors     = ["Ludovic Henry"]
  s.email       = ["ludovichenry.utbm@gmail.com"]
  s.homepage    = "https://github.com/ludovic-henry/web-debug-toolbar"
  s.summary     = "Web Debug Toolbar for Rails"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
end
