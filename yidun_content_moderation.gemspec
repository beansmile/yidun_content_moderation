$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "yidun_content_moderation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "yidun_content_moderation"
  spec.version     = YidunContentModeration::VERSION
  spec.authors     = ["MC"]
  spec.email       = ["mc@beansmile.com"]
  spec.homepage    = "https://github.com/beansmile/yidun_content_moderation"
  spec.summary     = ""
  spec.description = ""
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://github.com/beansmile/yidun_content_moderation"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.4", ">= 5.2.4.4"
  spec.add_dependency "httparty", "~> 0.18.0"

  spec.add_development_dependency "sqlite3"
end
