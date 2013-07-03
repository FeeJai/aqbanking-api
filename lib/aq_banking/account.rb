# encoding: utf-8

class AqBanking::Account < Struct.new(:blz, :kto)
  def transactions
    return []
  end
end