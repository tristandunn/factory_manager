# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "factory_manager"
  s.version     = "0.4.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tristan Dunn"]
  s.email       = "hello@tristandunn.com"
  s.homepage    = "https://github.com/tristandunn/factory_manager"
  s.summary     = "A factory manager of factory bots."
  s.description = "A factory manager of factory bots."
  s.license     = "MIT"
  s.metadata    = { "rubygems_mfa_required" => "true" }

  s.files        = Dir["lib/**/*"].to_a
  s.require_path = "lib"

  s.required_ruby_version = ">= 3.2"

  s.add_dependency "factory_bot", ">= 5"

  s.add_development_dependency "activerecord",        "8.0.2"
  s.add_development_dependency "appraisal",           "2.5.0"
  s.add_development_dependency "observer",            "0.1.2"
  s.add_development_dependency "ostruct",             "0.6.1"
  s.add_development_dependency "rake",                "13.2.1"
  s.add_development_dependency "rspec",               "3.13.0"
  s.add_development_dependency "rubocop",             "1.74.0"
  s.add_development_dependency "rubocop-factory_bot", "2.27.1"
  s.add_development_dependency "rubocop-performance", "1.24.0"
  s.add_development_dependency "rubocop-rake",        "0.7.1"
  s.add_development_dependency "rubocop-rspec",       "3.5.0"
  s.add_development_dependency "sqlite3",             "2.6.0"
  s.add_development_dependency "yard",                "0.9.37"
end
