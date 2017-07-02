# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/analyze_apk/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-analyze_apk'
  spec.version       = Fastlane::AnalyzeApk::VERSION
  spec.author        = %q{kochavi-daniel}
  spec.email         = %q{}

  spec.summary       = %q{Analyzes an apk to fetch: versionCode, versionName, apk size, etc.}
  spec.homepage      = "https://github.com/kochavi-daniel/fastlane-plugin-analyze-apk"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.43.0'
end
