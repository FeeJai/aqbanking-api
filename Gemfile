source 'https://rubygems.org'

ruby '2.0.0'

# sinatra & the application server
gem 'sinatra', '~> 1.4.3'
gem 'sinatra-contrib', '~> 1.4.0'

gem 'puma', '~> 2.1'

# responses are in JSON format
gem 'json', '~> 1.8'

# aqbanking sometimes returns XML
gem 'nokogiri', '~> 1.6'

# handles all necessary processes
gem 'foreman'
gem 'rake', '~> 10.0'

group :test do
  # testing frameworks in use
  gem 'rack-test', '~> 0.6.2'
  gem 'mocha', '~> 0.14'

  # automate the execution of tests
  gem 'guard-minitest'
end