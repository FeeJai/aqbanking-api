# encoding: utf-8

class AqBanking::Account < Struct.new(:blz, :kto)
  attr_reader :transactions

  def initialize *args
    @transactions = []
    super
  end
end