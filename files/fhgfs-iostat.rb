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
  @options['nodeid'] = nil
  @options['nodetype'] = 'storage'
  @options['history'] = 10
  @options['metric'] = nil
  @options['debug'] = false

  optparse = OptionParser.new do |opts|
    opts.on('-t', '--nodetype NODETYPE', String,'FhGFS nodetype') do |nodetype|
      @options['nodetype'] = nodetype
    end

    opts.on('--history SECONDS', Integer, 'FhGFS size of history in seconds') do |history|
      @options['history'] = history
    end
    
    opts.on('-m', '--metric METRIC', String, 'iostat metric to return', "Options: #{METRICS.join(", ")}") do |metric|
      @options['metric'] = metric
    end
    
    opts.on('-d', '--[no-]debug', 'enable debug output') do |d|
      @options['debug'] = d
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end
  
  begin
    optparse.parse!(args)
    @options['nodeid'] = args.first
    raise OptionParser::MissingArgument, "Missing NodeID" if @options['nodeid'].nil?
    raise OptionParser::InvalidOption, "Bad Metric" unless METRICS.include?(@options['metric'])
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts $!.to_s
    puts optparse
    exit
  end

  @options
end

def get_average(arr)
  average = arr.map { |x| x.to_f }.inject(:+) / arr.size.to_f
  average
end

opts = parse(ARGV)

raw_results = []
results = {}
metrics = {}

pp opts if opts['debug']


FHGFS_CTL_CMD = "/usr/bin/fhgfs-ctl --iostat --nodetype=#{opts['nodetype']} --history=#{opts['history']} #{opts['nodeid']}"

output = %x{#{FHGFS_CTL_CMD}}.chomp

output.each_line do |line|
  line.strip!
  next unless line =~ /^[0-9]+\s+.*$/
  values = line.gsub(/\s+/, ",").split(",")
  raw_results << values[1..-1]
end

METRICS.each_with_index do |column, index|
  results[column] = raw_results.map { |r| r[index] }
  metrics[column] = get_average(results[column])
end

printf("%.2f\n", metrics[@options['metric']])
exit 0
