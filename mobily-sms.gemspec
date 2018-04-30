
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mobily/sms/version"

Gem::Specification.new do |spec|
  spec.name          = "mobily-sms"
  spec.version       = Mobily::Sms::VERSION
  spec.authors       = ["MaJeD BoJaN"]
  spec.email         = ["bojanmajed@gmail.com"]

  spec.summary       = %q{integrate with mobilyws .}
  spec.description   = %q{mobily-sms integrated with mobilyws api's offers a SMS Gateway service “SMS A P I ”, that allows you easily connect Send-SMS service with your
applications, websites, or any kind of systems that you may have}
  spec.homepage      = "This gem will make your integration with mobilyws easier, In order to use mobily.ws API, you should have a Mobily.ws account from this link: http://mobily.ws/sms/index.php, "
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
