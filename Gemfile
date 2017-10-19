source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'sqlite3'
end
group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Custom gems

gem 'basic-stats'
gem 'chartkick'
gem 'devise', '~> 4.3'
gem 'draper'
gem 'haml', '~> 5.0', '>= 5.0.3'
gem 'haml-rails', '~> 1.0'
gem 'httpclient'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'materialize-sass', '~> 0.100.2'
gem 'pry-rails'
gem 'ransack'
gem 'rbma'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'whenever'

# Capistrano

gem 'capistrano', '~> 3.7', '>= 3.7.1'
gem 'capistrano-passenger', '~> 0.2.0'
gem 'capistrano-rails', '~> 1.2'
gem 'capistrano-rbenv', '~> 2.1'
gem 'parallel'
gem 'yaml_db'
