
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pragmatic_ql/version"

Gem::Specification.new do |spec|
  spec.name          = "pragmatic_ql"
  spec.version       = PragmaticQL::VERSION
  spec.authors       = ["Tomas Valent", "Charlie Tarr", "Rene Ivanov", "Anas Alaoui", "Alexander Sidorenko", "Matthijs Hovelynck"]
  spec.email         = ["equivalent@eq8.eu"]

  spec.summary       = %q{Simple query language for JSON based APIs}
  spec.description   = %q{Imagine GraphQL alike query language for JSON based APIs usecase but with really pragmatic implementation using GET requests and query string includes}
  spec.homepage      = "https://github.com/Pobble/pragmatic_ql"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "> 4" # I use goodies like .try?() .blank?()
  spec.add_development_dependency "bundler", "> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
