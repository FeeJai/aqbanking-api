# encoding: utf-8

##
# subset of transaction-element children.
#
# I've decided to skip localBankCode, localAccountNumber, localName because
# they'll always equal the associated account in my case
class AqBanking::Transaction < Struct.new(:remote_blz, :remote_kto, :remote_name)
end