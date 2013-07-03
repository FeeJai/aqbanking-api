# encoding: utf-8

require './application'

BASE_DIR = "#{__dir__}"

path = Pathname.new("#{BASE_DIR}/tmp/test_config")

config = AqBanking::Config.new(path.to_s)
account_manager = AqBanking::AccountManager.new(config)

user = AqBanking::User.new("App", ENV["TEST_BLZ"], ENV["TEST_CUSTOMER"], ENV["TEST_SERVER"])

user_manager = AqBanking::UserManager.new(config)
user_manager.add user

account_manager.refresh user, ENV["TEST_PIN"]

run Service.new(account_manager)