require 'test_helper'

class UserTest < MiniTest::Unit::TestCase
  def test_user_initialization
    user = AqBanking::User.new("example", "21090900", "11283123", "http://blog.nicolai86.eu")
    assert_equal "example", user.name
    assert_equal "21090900", user.bank
    assert_equal "11283123", user.userid
    assert_equal "http://blog.nicolai86.eu", user.server
    assert_equal 300, user.hbciversion
    assert_equal "pintan", user.tokentype
    assert_equal "1", user.context
  end
end