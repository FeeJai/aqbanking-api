require 'test_helper'

class AccountTest < MiniTest::Unit::TestCase
  def test_account_initialization
    account = AqBanking::Account.new("21090900", "2882788600")
    assert_equal "21090900", account.blz
    assert_equal "2882788600", account.kto
  end
end