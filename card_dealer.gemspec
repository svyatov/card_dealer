# frozen_string_literal: true

require_relative "lib/card_dealer/version"

Gem::Specification.new do |spec|
  spec.name = "card_dealer"
  spec.version = CardDealer::VERSION
  spec.authors = ["Leonid Svyatov"]
  spec.email = ["leonid@svyatov.com"]

  spec.summary = "A delightful card dealing companion for your digital table."
  spec.description = <<~DESC
    CardDealer is your go-to gem for creating, shuffling, and dealing decks of
    cards with ease. Whether you're building a poker night app or a virtual
    bridge club, CardDealer has got you covered. Enjoy customizable deck
    options, smooth shuffling algorithms, and simple yet powerful deck
    manipulation tools that bring the classic card game experience to life.
  DESC
  spec.homepage = "https://github.com/svyatov/card_dealer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
