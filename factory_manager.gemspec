# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "factory_manager"
  s.version     = "0.3.0"
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

  s.required_ruby_version = ">= 3.0"

  s.add_dependency "factory_bot", ">= 5"

  s.add_development_dependency "activerecord",        "7.0.7.2"
  s.add_development_dependency "appraisal",           "2.5.0"
  s.add_development_dependency "rake",                "13.0.6"
  s.add_development_dependency "rspec",               "3.12.0"
  s.add_development_dependency "rubocop",             "1.56.2"
  s.add_development_dependency "rubocop-performance", "1.19.0"
  s.add_development_dependency "rubocop-rake",        "0.6.0"
  s.add_development_dependency "rubocop-rspec",       "2.23.2"
  s.add_development_dependency "sqlite3",             "1.6.4"
  s.add_development_dependency "yard",                "0.9.34"
end
