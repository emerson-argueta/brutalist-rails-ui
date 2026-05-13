require_relative "lib/brutalist_rails_ui/version"

Gem::Specification.new do |spec|
  spec.name        = "brutalist_rails_ui"
  spec.version     = BrutalistRailsUi::VERSION
  spec.authors     = ["Emerson Argueta"]
  spec.summary     = "Neobrutalist UI components for Rails — Tailwind directives, view helpers, and partials."
  spec.license     = "MIT"

  spec.files = Dir[
    "lib/**/*",
    "app/**/*",
    "LICENSE",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.1"
  spec.add_dependency "actionview", ">= 7.1"
end
