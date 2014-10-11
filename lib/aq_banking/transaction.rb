# encoding: utf-8

##
# subset of transaction-element children.
#
# I've decided to skip localBankCode, localAccountNumber, localName because
# they'll always equal the associated account in my case
class AqBanking::Transaction < Struct.new(:remote_blz, :remote_kto, :remote_name, :date, :amount_cents, :currency)
  def self.parse node
    kto = node.xpath("remoteBankCode/value").first.content.strip
    blz = node.xpath("remoteAccountNumber/value").first.content.strip
    name = node.xpath("remoteName/value").first.content.strip
    date_day = node.xpath("valutaDate/date/day").first.content.strip
    date_month = node.xpath("valutaDate/date/month").first.content.strip
    date_year = node.xpath("valutaDate/date/year").first.content.strip
    amount_currency = node.xpath("value/currency/value").first.content.strip
    amount_cents = node.xpath("value/value/value").first.content.strip.gsub(/\/\d+/,'')
    date = Date.new(date_year.to_i, date_month.to_i, date_day.to_i)
    self.new(blz, kto, name, date, amount_cents, amount_currency)
  end
end
