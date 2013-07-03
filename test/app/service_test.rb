require 'test_helper'

class ServiceTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  attr_accessor :account_manager

  def app
    ::Service.new(self.account_manager)
  end

  def setup
    @account_manager = ::AqBanking::AccountManager.new(::AqBanking::Config.new("#{BASE_DIR}/tmp/service"))
  end

  def test_returns_available_accounts
    # no accounts available
    get '/accounts'
    assert last_response.ok?

    response = JSON.parse last_response.body
    assert_equal [], response['accounts']

    # fake that we got an account
    account_manager.stubs(:list).returns([::AqBanking::Account.new("21090900", "2882788600")])
    get '/accounts'
    assert last_response.ok?

    response = JSON.parse last_response.body
    refute_equal [], response['accounts']

    account = response['accounts'].first
    assert_equal "21090900", account['blz']
    assert_equal "2882788600", account['kto']
  end

  def test_returns_404_if_account_is_unknown
    get '/accounts/21090900-2882788600/transactions'
    assert_equal 404, last_response.status
  end

  def test_returns_transactions_if_account_is_known
    account_manager.stubs(:list).returns([::AqBanking::Account.new("21090900", "2882788600")])

    get '/accounts/21090900-2882788600/transactions'
    assert last_response.ok?

    # response = JSON.parse last_response.body
    # assert [], response['transactions']
  end
end