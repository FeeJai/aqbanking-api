# encoding: utf-8
class Service < Sinatra::Base
  attr_accessor :account_manager

  configure :development do
    register Sinatra::Reloader

    also_reload 'app/models/account'
  end

  # returns a list of all known aqbanking accounts
  # note that the list is populate once, at startup. See config.ru for details
  get '/accounts' do
    response = {
      accounts: account_manager.list.map(&:to_h)
    }
    return JSON.dump(response)
  end

  get '/accounts/:blz-:kto/transactions' do
    account = account_manager.find params[:blz], params[:kto]

    if account
      response = {
        transactions: account.transactions
      }
      return JSON.dump(response)
    else
      halt 404, "Unknown account"
    end
  end

  def initialize account_manager
    @account_manager = account_manager
    super()
  end
end