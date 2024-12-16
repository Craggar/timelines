require_relative "lib/timelines/version"

Gem::Specification.new do |spec|
  spec.name = "timelines"
  spec.version = Timelines::VERSION
  spec.authors = ["Craig Gilchrist"]
  spec.email = ["craig.a.gilchrist@gmail.com"]
  spec.homepage = "https://github.com/Craggar/timelines"
  spec.summary = "Library for managing historical records."
  spec.description = <<-EOF
    Provides an Ephemeral module that can be included in any ActiveRecord model to
    provide a simple way to track active/historical/past records.
  EOF
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Craggar/timelines"
  spec.metadata["changelog_uri"] = "https://github.com/Craggar/timelines/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.0"
end
