#!/usr/bin/env ruby

require 'optparse'
require 'pp'

METRICS = [
  'write',
  'read',
  'reqs',
  'qlen',
  'bsy',
]

def parse(args)
  mandatory_options = ['nodeid','nodetype','history','metric']
  @options = {}
  @options['nodeid'] = 'all'
  @options['nodetype'] = 'storage'
  @options['history'] = '10'
  @options['metric'] = 'write'
  @options['debug'] = false

  optparse = OptionParser.new do |opts|
    opts.on('-t', '--nodetype NODETYPE', 'FhGFS nodetype') do |nodetype|
      @options['nodetype'] = nodetype
    end

    opts.on('--history SECONDS', 'FhGFS size of history in seconds') do |history|
      @options['history'] = history
    end
    
    opts.on('-m', '--metric METRIC', 'iostat metric to return', "Options: #{METRICS.join(", ")}") do |metric|
      @options['metric'] = metric
    end
    
    opts.on('-d', '--[no-]debug', 'enable debug output') do |d|
      @options['debug'] = d
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit 1
    end
  end
  
  begin
    optparse.parse!(args)
    @options['nodeid'] = args.first unless args.empty?
    raise OptionParser::MissingArgument, "Missing NodeID" if @options['nodeid'].nil?
    raise OptionParser::InvalidOption, "Bad Metric" unless METRICS.include?(@options['metric'])
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts $!.to_s
    puts optparse
    exit 1
  end

  @options
end

def debug_output(msg, obj = nil, opts = {})
  return unless opts['debug']
  puts "DEBUG: #{msg}"
  pp obj if obj
end

def get_average(arr)
  average = arr.map { |x| x.to_f }.inject(:+) / arr.size.to_f
  sprintf("%.2f", average)
end

opts = parse(ARGV)

raw_results = []
results = {}
metrics = {}

debug_output("Options:", opts, opts)

FHGFS_CTL_CMD = []
FHGFS_CTL_CMD << "sudo"
FHGFS_CTL_CMD << "/usr/bin/fhgfs-ctl --iostat"
FHGFS_CTL_CMD << "--nodetype=#{opts['nodetype']}"
FHGFS_CTL_CMD << " --history=#{opts['history']}"
FHGFS_CTL_CMD << opts['nodeid'] unless opts['nodeid'] =~ /all/

cmd = FHGFS_CTL_CMD.join(" ")
debug_output("Command:", cmd, opts)

output = `#{cmd}`.chomp
debug_output("Raw output:", output, opts)


output.each_line do |line|
  line.strip!
  next unless line =~ /^[0-9]+\s+.*$/
  values = line.gsub(/\s+/, ",").split(",")
  raw_results << values[1..-1]
end

debug_output("Raw results:", raw_results, opts)

METRICS.each_with_index do |column, index|
  results[column] = raw_results.map { |r| r[index] }
  metrics[column] = get_average(results[column])
end

debug_output("Metrics:", metrics, opts)

puts metrics[@options['metric']]

exit 0
