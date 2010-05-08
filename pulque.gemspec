spec = Gem::Specification.new do |s|
  s.platform  = Gem::Platform::RUBY
  s.name = "pulque"
  s.version = "0.2"
  s.summary = "Collection of tools to maintain Parallel Development Environments."
  s.description = "Pulque is a collection of applications written in Ruby and Bash scripting to maintain parallel development environments."

  s.author = "Mario Carrion"
  s.email = "mario@carrion.mx"
  s.homepage = "http://github.com/mariocarrion/pulque"
  s.rubyforge_project = "pulque"

  require 'rake'

  # etc/ and man/ are not included, doesn't make any sense
  s.files = FileList[
  #s.files = FileList["bin/*",
                     "lib/pulque/*",
                     "lib/pulque/changelogs/*",
                     "lib/pulque/repositories/*",
                     "lib/pulque/utils/*",
                     "test/*.rb",
		     "LICENSE"].to_a
#  s.bindir = "bin"
  s.has_rdoc = false

  s.extra_rdoc_files = ["README"]
  # Sadly the subversion gem on rubygems is Windows only :(
  s.add_dependency("systemu",">=1.2.0")
  s.add_dependency("git",">=1.2.5")
end
