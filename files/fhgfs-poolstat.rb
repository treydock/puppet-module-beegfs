#!/usr/bin/env ruby

require 'optparse'
require 'pp'

METRICS = [
  'pool',
  'total',
  'free',
  'itotal',
  'ifree',
]

VALID_NODETYPES = [ 'storage', 'metadata' ]

SIZE_CONV = {
  'B' => 1,
  'KB' => 1000**1,
  'MB' => 1000**2,
  'GB' => 1000**3,
  'TB' => 1000**4,
  'PB' => 1000**5,
  'EB' => 1000**6,
}

INODE_CONV = {
  'M' => 10**6,
  'G' => 10**9,
  'T' => 10**12,
  'P' => 10**15,
  'E' => 10**18,
  'Z' => 10**21,
}

def parse(args)
  mandatory_options = ['nodeid','nodetype','metric']
  @options = {}
  @options['nodeid'] = nil
  @options['nodetype'] = 'storage'
  @options['metric'] = nil
  @options['debug'] = false

  optparse = OptionParser.new do |opts|
    opts.on('-t', '--nodetype NODETYPE', 'FhGFS nodetype', "Options: #{VALID_NODETYPES.join(", ")}") do |nodetype|
      @options['nodetype'] = nodetype
    end

    opts.on('-m', '--metric METRIC', 'iostat metric to return', "Options: #{METRICS.join(", ")}") do |metric|
      @options['metric'] = metric
    end
    
    opts.on('-d', '--[no-]debug', 'enable debug output') do |debug|
      @options['debug'] = debug
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit 1
    end
  end
  
  begin
    optparse.parse!(args)
    @options['nodeid'] = args.first
    raise OptionParser::MissingArgument, "Missing NodeID" if @options['nodeid'].nil?
    raise OptionParser::InvalidOption, "Bad Metric" unless METRICS.include?(@options['metric'])
    raise OptionParser::InvalidOption, "Invalid nodetype" unless VALID_NODETYPES.include?(@options['nodetype'])
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

# Intended to remove the square brackets outputed by fhgfs-ctl
def format_pool(str)
  match = str.match(/([A-Za-z]+)/)
  match[1]
end

# Formats the size to Bytes
def format_size(str)
  match = str.match(/^([0-9.]+)(#{SIZE_CONV.keys.join("|")})$/)
  size = match[1]
  unit = match[2]
  value = size.to_f * SIZE_CONV[unit]
  sprintf('%.0f', value)
end

# Formats the inode to full value without unit suffixes
def format_inodes(str)
  match = str.match(/^([0-9.]+)(#{INODE_CONV.keys.join("|")})$/)
  num = match[1]
  unit = match[2]
  value = num.to_f * INODE_CONV[unit]
  sprintf('%.0f', value)
end

opts = parse(ARGV)

raw_results = []

debug_output("Options:", opts, opts)

FHGFS_CTL_CMD = []
FHGFS_CTL_CMD << "sudo"
FHGFS_CTL_CMD << "/usr/bin/fhgfs-ctl --listpools --spaceinfo"
FHGFS_CTL_CMD << "--nodetype=#{opts['nodetype']}"

cmd = FHGFS_CTL_CMD.join(" ")
debug_output("Command:", cmd, opts)

output = `#{cmd}`.chomp
debug_output("Raw output:", output, opts)

output.each_line do |line|
  line.strip!
  next unless line =~ /^[0-9]+\s+.*$/
  values = line.gsub(/\s+/, ",").split(",")
  raw_results << values
end

results = raw_results.collect do |r|
  result = {}
  [
    ['targetid', 0, nil],
    ['pool', 1, 'format_pool'],
    ['total', 2, 'format_size'],
    ['free', 3, 'format_size'],
    ['itotal', 4, 'format_inodes'],
    ['ifree', 5, 'format_inodes'],
    
  ].each do |name, index, method|
    if method
      value = send(method.to_sym, r[index])
    else
      value = r[index]
    end
    result[name] = value
  end
  result
end

debug_output("Results:", results, opts)

node_results = results.find { |r| r['targetid'] == @options['nodeid'] }
puts node_results[@options['metric']]

exit 0
