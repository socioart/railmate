require_relative "lib/railmate/version"

Gem::Specification.new do |spec|
  spec.name          = "railmate"
  spec.version       = Railmate::VERSION
  spec.authors       = ["labocho"]
  spec.email         = ["labocho@penguinlab.jp"]

  spec.summary       = "Utility for Rails app operation"
  spec.description   = "Utility for Rails app operation. It provides commands to check revision, open in browser, SSH to server, and download or view log files."
  spec.homepage      = "https://github.com/socioart/railmate"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/socioart/railmate"
  spec.metadata["changelog_uri"] = "https://github.com/socioart/railmate/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) {|f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "net-scp", "~> 4.0"
  spec.add_dependency "net-ssh", "~> 7.3"
  spec.add_dependency "thor", "~> 1.3"
end
