# encoding: utf-8

##
# aqhbci-tool4 adduser/ deluser options
class AqBanking::User
  attr_accessor :name, :bank, :userid, :server, :hbciversion

  def initialize name, bank, userid, server, hbciversion = 300
    # all parameters, as used by aqhbci-tool:
    # --username
    @name = name
    # --bank
    @bank = bank
    # --user
    @userid = userid
    # --server
    @server = server
    # --hbciversion
    @hbciversion = hbciversion
  end

  # --tokentype
  def tokentype
    return "pintan"
  end

  # --context=1
  def context
    return "1"
  end
end