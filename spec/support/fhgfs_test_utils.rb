module FhgfsTestUtils
  def sudo_and_log(vm, cmd)
    @logger.debug("Running command: '#{cmd}'")
    result = ""
    @env.vms[vm].channel.sudo("cd /tmp && #{cmd}") do |ch, data|
      result << data
      @logger.debug(data)
    end
    result
  end

  def sudo_and_expect_result(vm, cmd, expected)
    result = sudo_and_log(vm, "#{cmd}'")

    result.sub!(/stdin: is not a tty/, '')
    result.strip! 

    ok = result == expected
    @logger.debug("Expected: #{expected} => #{ok ? 'OK' : 'BAD'}")
 
    if !ok
      raise "An unexpected result returned - result: '#{result}' / expected: '#{expected}'"
    end 
  end
end
