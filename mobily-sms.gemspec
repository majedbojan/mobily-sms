
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mobily/sms/version"

Gem::Specification.new do |spec|
  spec.name          = "mobily-sms"
  spec.version       = Mobily::Sms::VERSION
  spec.authors       = ["MaJeD BoJaN"]
  spec.email         = ["bojanmajed@gmail.com"]

  spec.summary       = 'integrate with mobilyws'
  spec.description   = 'This will help developers to integrate with mobilews service'
  spec.homepage      = 'https://github.com/MajedBojan/mobily-sms'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
