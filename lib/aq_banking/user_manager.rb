# encoding: utf-8
require 'open3'
require 'nokogiri'

class AqBanking::UserManager
  include AqBanking
  attr_accessor :config

  def initialize config
    @config = config
  end

  def list
    command = aqhbci "listusers --xml"
    stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)

    results = []
    exit_status = wait_thr.value
    if exit_status.success?
      doc = Nokogiri::XML(stdout.read)
      doc.xpath('//user').each do |user_node|
        user = ::AqBanking::User.new(
          user_node.xpath('//UserName').first.content,
          user_node.xpath('//BankCode').first.content,
          user_node.xpath('//UserId').first.content,
          ""
        )
        results << user
      end
    end

    return results
  end

  # note that if adding a user fails you might need to supply a valid pin.
  # suppling a pin will invoke getsysid which is necessary in most first-time
  # scenarios
  def add user, pin = nil
    command = aqhbci <<-CMD
      adduser \
      --tokentype=#{user.tokentype} \
      --context=#{user.context} \
      --bank=#{user.bank} \
      --user=#{user.userid} \
      --server=#{user.server} \
      --username=#{user.name} \
      --hbciversion=#{user.hbciversion}
    CMD
    stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)
    success = wait_thr.value.success?

    if pin && success
      with_secure_pin user, pin do |f|
        sysid_command = aqhbci("getsysid --user=#{user.userid}", "--pinfile=#{f.path.strip}").strip
        stdin, stdout, stderr, wait_thr = Open3.popen3(sysid_command)
        success = success && wait_thr.value.success?
      end
    end
    return success
  end

  def remove user
    command = aqhbci "deluser --user=#{user.userid}"
    stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)
    exit_status = wait_thr.value
    return exit_status.success?
  end
end