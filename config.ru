# encoding: utf-8

require './application'

BASE_DIR = "#{__dir__}"

path = Pathname.new("#{BASE_DIR}/tmp/test_config")

config = AqBanking::Config.new(path.to_s)
account_manager = AqBanking::AccountManager.new(config)

user = AqBanking::User.new("App", ENV["TEST_BLZ"], ENV["TEST_CUSTOMER"], ENV["TEST_SERVER"])

user_manager = AqBanking::UserManager.new(config)
user_manager.add user

if account_manager.refresh user, ENV["TEST_PIN"]
  p "refresh successful"
  account = account_manager.list.last
  if account_manager.update_transactions user, account, ENV["TEST_PIN"]
    p "updating transactions for #{account.blz}, #{account.kto}"
    p account.transactions
    account_manager.update account
  else
    p "updating transactions failed"
  end
else
  p "refresh failed"
end

run Service.new(account_manager)