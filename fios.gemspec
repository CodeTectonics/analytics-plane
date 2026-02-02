# frozen_string_literal: true

require_relative "lib/fios/version"

Gem::Specification.new do |spec|
  spec.name = "fios"
  spec.version = Fios::VERSION
  spec.authors = ["Mark Harbison"]
  spec.email = ["mark@tyne-solutions.com"]

  spec.summary = "A data analytics framework for building charts, dashboards, and reports in Ruby."
  spec.description = "A data analytics framework for building charts, dashboards, and reports in Ruby."
  spec.homepage = "https://github.com/CodeTectonics/fios"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "rails", ">= 6.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
