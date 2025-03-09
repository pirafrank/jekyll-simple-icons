# frozen_string_literal: true

require_relative "lib/jekyll-simple-icons/version.rb"

Gem::Specification.new do |spec|
  spec.name = "jekyll-simple-icons"
  spec.version = Jekyll::SimpleIcons::VERSION
  spec.authors = ["Francesco Pira"]
  spec.email = ["dev@fpira.com"]

  spec.summary = "Jekyll plugin to easily add Simple Icons to your site"
  spec.description = "A plugin that makes it easy to incorporate Simple Icons into your Jekyll website, providing access to a vast collection of popular brands icons."
  spec.homepage = "https://github.com/pirafrank/jekyll-simple-icons"

  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/pirafrank/jekyll-simple-icons/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/pirafrank/jekyll-simple-icons/issues"

  spec.add_runtime_dependency "jekyll", ">= 3.7", "< 5.0"

  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.14"
end
