require 'test_helper'

class UserManagerTest < MiniTest::Unit::TestCase
  attr_accessor :config, :user_manager, :path

  def setup
    self.path = Pathname.new("./tmp/test_config")
    self.config = AqBanking::Config.new(path.to_s)
    self.user_manager = AqBanking::UserManager.new(config)
  end

  def teardown
    FileUtils.rm_rf self.path.to_s
  end

  def test_add_user_succeeds
    user = AqBanking::User.new("A", "21090900", "11283123", "http://blog.nicolai86.eu")
    assert self.user_manager.add user

    refute self.user_manager.add user
  end

  def test_del_user_fails_if_unknown
    user = AqBanking::User.new("B", "21090900", "11283123", "http://blog.nicolai86.eu")
    refute self.user_manager.remove user
  end

  def test_del_user_succeeds_if_known
    user = AqBanking::User.new("A", "21090900", "11283123", "http://blog.nicolai86.eu")
    self.user_manager.add user

    assert self.user_manager.remove user
  end

  def test_list_empty
    assert_equal [], self.user_manager.list
  end

  def test_list_with_user
    user = AqBanking::User.new("A", "21090900", "11283123", "http://blog.nicolai86.eu")
    assert self.user_manager.add user

    known_users = self.user_manager.list
    refute_equal [], known_users

    listed_user = known_users.first

    assert_equal user.bank, listed_user.bank
    assert_equal user.userid, listed_user.userid
  end

  def test_add_user_with_in
    # this test won't run unless you specify all required TEST_* parameters.
    # see .env.sample for a list
    skip if ENV["TEST_LIVE"] != "true"
    user = AqBanking::User.new("Test", ENV["TEST_BLZ"], ENV["TEST_CUSTOMER"], ENV["TEST_SERVER"])

    self.user_manager.add user, ENV["TEST_PIN"]
  end
end