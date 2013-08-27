#!/usr/bin/env ruby

require 'optparse'
require 'pp'
require 'facter'

def parse(args)
  mandatory_options = ['nodetype','metric']
  @options = {}
  @options['nodetype'] = 'storage'
  @options['metric'] = nil
  @options['list'] = false
  @options['debug'] = false

  optparse = OptionParser.new do |opts|
    opts.on('-t', '--nodetype NODETYPE', 'FhGFS nodetype') do |nodetype|
      @options['nodetype'] = nodetype
    end

    opts.on('-m', '--metric METRIC', 'iostat metric to return') do |metric|
      @options['metric'] = metric
    end

    opts.on('l', '--list', 'list available metric names') do |list|
      @options['list'] = list
      @options['metric'] = 'all'
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
    missing_options = mandatory_options.select { |o| @options[o].nil? }
    raise OptionParser::MissingArgument, "Missing argument: #{missing_options.join(', ')}" unless missing_options.empty?
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

def get_available_metrics(str, opts = {})
  str.scan(/\[[a-zA-Z0-9\-]+\]/).flatten.map { |m| m[/\[(.*)\]/, 1] }
end

def get_metric_value(str, opts = {})
  match = str.match(/\s+([0-9]+) \[#{@options['metric']}\]/) || []
  debug_output("Metric match:", match, opts)

  metric_value = match[1] || ""
  metric_value
end

opts = parse(ARGV)

raw_results = []
output_matches = []

debug_output("Options:", opts, opts)

FHGFS_CTL_CMD = []
FHGFS_CTL_CMD << "sudo"
FHGFS_CTL_CMD << "/usr/bin/fhgfs-ctl --clientstats"
FHGFS_CTL_CMD << "--nodetype=#{opts['nodetype']}"
FHGFS_CTL_CMD << "--allstats"
FHGFS_CTL_CMD << "--rwunit=B"
FHGFS_CTL_CMD << "--interval=0"

cmd = FHGFS_CTL_CMD.join(" ")
debug_output("Command:", cmd, opts)

output = `#{cmd}`.chomp
debug_output("Raw output:", output, opts)

interfaces = Facter.interfaces.split(",")
debug_output("Interfaces:", interfaces, opts)

ip_addresses = interfaces.collect do |interface|
  Facter["ipaddress_#{interface}"].value
end
debug_output("IP Addresses:", ip_addresses, opts)

output.each_line do |line|
  line_ip = line[/^([0-9.]+)\s+.*$/, 1]
  next if line_ip.nil?
  if ip_addresses.include?(line_ip)
    output_matches << line.strip
  end
end

debug_output("Output lines matching IP:", output_matches, opts)

if @options['list']
  puts get_available_metrics(output_matches.first, opts)
else
  puts get_metric_value(output_matches.first, opts)
end

exit 0
