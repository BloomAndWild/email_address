# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_addr/version'

Gem::Specification.new do |spec|
  spec.name          = "email_addr"
  spec.version       = EmailAddr::VERSION
  spec.authors       = ["Allen Fair"]
  spec.email         = ["allen.fair@gmail.com"]
  spec.description   = %q{The EmailAddr Gem to work with and validate email addresses.}
  spec.summary       = %q{This gem provides a ruby language library for working with and validating email addresses. By default, it validates against conventional usage, the format preferred for user email addresses. It can be configured to validate against RFC “Standard” formats, common email service provider formats, and perform DNS validation.}
  spec.homepage      = "https://github.com/afair/email_address"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest",     "~> 5.8.3"
  spec.add_development_dependency "bundler",      "~> 1.3"
  if RUBY_PLATFORM == 'java'
    spec.add_development_dependency "activerecord", "=  4.2.5"
    spec.add_development_dependency "activerecord-jdbcsqlite3-adapter", '=1.3.19'
  else
    spec.add_development_dependency "activerecord", "~> 5.1.3"
    spec.add_development_dependency "sqlite3"
  end
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.add_dependency "simpleidn"
  spec.add_dependency "netaddr"
end
