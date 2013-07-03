require 'test_helper'

class AccountManagerTest < MiniTest::Unit::TestCase
  attr_accessor :config, :account_manager, :user_manager, :path

  def setup
    self.path = Pathname.new("./tmp/test_config")
    self.config = AqBanking::Config.new(path.to_s)
    self.account_manager = AqBanking::AccountManager.new(config)
  end

  def teardown
    FileUtils.rm_rf self.path.to_s
  end

  def test_list_is_empty
    assert_equal [], self.account_manager.list
  end

  def test_find_with_blz_kto
    self.account_manager.stubs(:list).returns([::AqBanking::Account.new("21090900","2882788500"), ::AqBanking::Account.new("21090900","2882788600")])
    refute_equal [], self.account_manager.find("21090900", "2882788600")
  end

  def test_refresh
    # this test won't run unless you specify all required TEST_* parameters.
    # see .env.sample for a list
    skip if ENV["TEST_LIVE"] != "true"

    user = AqBanking::User.new("Test", ENV["TEST_BLZ"], ENV["TEST_CUSTOMER"], ENV["TEST_SERVER"])

    user_manager = AqBanking::UserManager.new(config)
    user_manager.add user

    account_manager.refresh user, ENV["TEST_PIN"]

    known_accounts = account_manager.list
    refute_equal [], known_accounts
  end

  def test_transaction_loading
    # this test won't run unless you specify all required TEST_* parameters.
    # see .env.sample for a list
    skip if ENV["TEST_LIVE"] != "true"

    user = AqBanking::User.new("Test", ENV["TEST_BLZ"], ENV["TEST_CUSTOMER"], ENV["TEST_SERVER"])

    user_manager = AqBanking::UserManager.new(config)
    user_manager.add user

    account_manager.refresh user, ENV["TEST_PIN"]

    account = account_manager.list.first
    assert_equal [], account.transactions

    account_manager.update_transactions user, account, ENV["TEST_PIN"]
    refute_equal [], account.transactions
  end
end