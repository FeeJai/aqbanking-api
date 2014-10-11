# encoding: utf-8

$:.unshift File.dirname(__FILE__)

module AqBanking
  def with_secure_pin user, pin, &block
    # create a tempfile and make sure only we can read it.
    f = Tempfile.new("pin_#{user.bank}_#{user.userid}", "#{BASE_DIR}/tmp")
    File.chmod(0400, f.path)

    f.write "PIN_#{user.bank}_#{user.userid} = \"#{pin}\"\n"
    f.flush

    yield f if block_given?

    f.close
    f.unlink
  end

  def aqhbci command, global_options = ""
    return <<-CMD
      aqhbci-tool4 --acceptvalidcerts --noninteractive --charset=utf-8 --cfgfile=#{config.path} \
        #{global_options} \
        #{command}
    CMD
  end

  def aqcli command, global_options = ""
    return <<-CMD
      aqbanking-cli --acceptvalidcerts --noninteractive --charset=utf-8 --cfgdir=#{config.path} \
        #{global_options} \
        #{command}
    CMD
  end
end

require "aq_banking/config"
require "aq_banking/user"
require "aq_banking/user_manager"
require "aq_banking/account"
require "aq_banking/account_manager"
