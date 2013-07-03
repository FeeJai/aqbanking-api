require 'test_helper'

class ConfigTest < MiniTest::Unit::TestCase
  def test_config_path
    config = AqBanking::Config.new(".")
    assert_equal ".", config.path
  end
end