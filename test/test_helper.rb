ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'test/unit'
require 'rack/test'
require 'mocha/setup'

BASE_DIR = "#{__dir__}/.."

require File.expand_path '../../application.rb', __FILE__