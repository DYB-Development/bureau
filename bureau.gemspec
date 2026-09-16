require_relative "lib/bureau/version"

Gem::Specification.new do |spec|
  spec.name        = "bureau"
  spec.version     = Bureau::VERSION
  spec.authors     = [ "tylercschneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/DYB-Development/bureau"
  spec.summary     = "Settings sections for Rails apps: one shell, many registrars"
  spec.description = "Bureau owns a settings page, the list of sections on it, the route each " \
    "section is served at, and the check for who may see a section. It ships user sections itself, " \
    "and other gems and the app register their own. Each thing a person can do is a plain object a " \
    "page or an API can call."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "keystone_ui", ">= 0.9"
end
