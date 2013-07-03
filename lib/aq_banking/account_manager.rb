# encoding: utf-8
require 'open3'
require 'tempfile'

class AqBanking::AccountManager
  include AqBanking
  attr_accessor :config

  def initialize config
    @config = config
  end

  def list
    stdin, stdout, stderr, wait_thr = Open3.popen3(aqhbci("listaccounts").strip)
    results = []

    exit_status = wait_thr.value
    if exit_status.success?
      stdout.read.each_line do |line|
        if line =~ /Account \d*: Bank: (\d+) Account Number: (\d+)/
          account = ::AqBanking::Account.new($1, $2)
          results << account
        end
      end
    end

    return results
  end

  def find blz, kto
    return self.list.select { |account| account.blz == blz && account.kto == kto }.first
  end

  def refresh user, pin
    with_secure_pin user, pin do |f|
      command = aqhbci "getaccounts --bank=#{user.bank} --user=#{user.userid}", "--pinfile=#{f.path.strip}"

      stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)
      exit_status = wait_thr.value

      wait_thr.join
      return exit_status.success?
    end
    return false
  end

  def update_transactions user, account, pin
    with_secure_pin user, pin do |f|
      context_file = Tempfile.new "#{account.blz}_#{account.kto}_context.tmp", "#{BASE_DIR}/tmp"

      request_transactions = <<-CMD
         request \
           --bank=#{account.blz} \
           --account=#{account.kto} \
           --transactions \
           --ctxfile=#{context_file.path.to_s}
      CMD
      command = aqcli request_transactions, "--pinfile=#{f.path.strip}"
      stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)
      wait_thr.join

      if wait_thr.value.success?
        list_transactions = <<-CMD
          listtrans \
            --bank=#{account.blz} \
            --account=#{account.kto} \
            --ctxfile=#{context_file.path.to_s} \
            --exporter=xmldb
        CMD
        command = aqcli list_transactions, "--pinfile=#{f.path.strip}"
        stdin, stdout, stderr, wait_thr = Open3.popen3(command.strip)

        doc = Nokogiri::XML(stdout.read)
        doc.xpath('//transaction').each do |transaction_node|
          transaction = ::AqBanking::Transaction.new()
          account.transactions << transaction
        end

        wait_thr.join
        return wait_thr.value.success?
      end

      return false
    end
    return false
  end
end