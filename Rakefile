# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task :default do
  sh "rake -AT"
end

task lint: :rubocop

task :changelog do
  sh "git cliff --tag #{Gem::Specification.load('jekyll-simple-icons.gemspec').version} -o CHANGELOG.md"
end

task :mkrelease do
  version = Gem::Specification.load("jekyll-simple-icons.gemspec").version
  sh "git cliff --tag #{version} -o CHANGELOG.md"
  sh "git add CHANGELOG.md"
  sh "git commit -m 'chore: update CHANGELOG.md'"
  sh "git tag -s -a -m 'v#{version}' #{version}"
  sh "git push origin #{version}"
end

task :build do
  sh "gem build jekyll-simple-icons.gemspec"
end

task :publish do
  version = Gem::Specification.load("jekyll-simple-icons.gemspec").version
  gem_file = "jekyll-simple-icons-#{version}.gem"
  sh "gem push #{gem_file}"
end
