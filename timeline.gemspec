require_relative "lib/timeline/version"

Gem::Specification.new do |spec|
  spec.name        = "timeline"
  spec.version     = Timeline::VERSION
  spec.authors     = ["Craig Gilchrist"]
  spec.email       = ["craig.a.gilchrist@gmail.com"]
  spec.homepage    = "https://github.com/Craggar/timeline"
  spec.summary     = "Library for managing historical records."
  spec.description = "Library for managing historical records."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Craggar/timeline"
  spec.metadata["changelog_uri"] = "https://github.com/Craggar/timeline/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.0"
end
