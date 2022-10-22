# frozen_string_literal: true

require_relative "lib/awesome_errors/version"

Gem::Specification.new do |spec|
  spec.name = "awesome_errors"
  spec.version = AwesomeErrors::VERSION
  spec.authors = ["Rui Freitas"]
  spec.email = ["rui.ferreira.freitas@gmail.com"]

  spec.summary = "Easily add errors to your service objects and Ruby classes."
  spec.description = "AwesomeErrors is a simply way to add errors to your Ruby objects and classes."
  spec.homepage = "https://github.com/rodloboz/awesome_errors"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rodloboz/awesome_errors"
  spec.metadata["changelog_uri"] = "https://github.com/rodloboz/awesome_errors/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
  spec.metadata["rubygems_mfa_required"] = "true"
end
