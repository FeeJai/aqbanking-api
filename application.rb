# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default, :test)

# add lib path to load path
require './lib/aq_banking'

require 'json'

require 'sinatra/base'
require 'sinatra/reloader'

Dir[File.join("app", "**/*.rb")].each do |file|
  require "./#{file}"
end