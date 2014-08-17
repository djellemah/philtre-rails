source 'https://rubygems.org'

# Specify your gem's dependencies in philtre-rails.gemspec
gemspec

if (local_philtre = Pathname("#{ENV['HOME']}/projects/philtre")).exist?
  gem 'philtre', path: local_philtre
  gem 'pry'
  gem 'pry-byebug'
  gem 'simplecov'
end
