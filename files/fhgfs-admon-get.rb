#!/usr/bin/env ruby

require 'optparse'
require 'pp'
require "rexml/document"
require 'net/http'

DATA_MAPPER = {
  'storage' => [
    {:metric => 'read', :xpath => '//diskPerfRead/value', :uri_prefix => 'XML_Storagenode', :attr => 'time', :text => true },
    {:metric => 'avgread', :xpath => '//diskPerfAverageRead/value', :uri_prefix => 'XML_Storagenode', :attr => 'time', :text => true },
    {:metric => 'write', :xpath => '//diskPerfWrite/value', :uri_prefix => 'XML_Storagenode', :attr => 'time', :text => true },
    {:metric => 'avgwrite', :xpath => '//diskPerfAverageWrite/value', :uri_prefix => 'XML_Storagenode', :attr => 'time', :text => true },
    {:metric => 'diskspacetotal', :xpath => '//storageTargets/target', :uri_prefix => 'XML_Storagenode', :attr => 'diskSpaceTotal', :text => false },
    {:metric => 'diskspacefree', :xpath => '//storageTargets/target', :uri_prefix => 'XML_Storagenode', :attr => 'diskSpaceFree', :text => false },
    {:metric => 'status', :xpath => '//general/status', :uri_prefix => 'XML_Storagenode', :attr => false, :text => true },
  ],
  'meta' => [
    {:metric => 'workrequests', :xpath => '//workRequests/value', :uri_prefix => 'XML_Metanode', :attr => 'time', :text => true },
    {:metric => 'queuedrequests', :xpath => '//queuedRequests/value', :uri_prefix => 'XML_Metanode', :attr => 'time', :text => true },
    {:metric => 'status', :xpath => '//general/status', :uri_prefix => 'XML_Metanode', :attr => false, :text => true },
  ],
}

def parse(args)
  mandatory_options = ['admon_host','nodeid','nodetype','metric']
  @options = {}
  @options[:admon_host] = nil
  @options[:nodeid] = `hostname`.strip
  @options[:nodenumid] = nil
  @options[:nodetype] = 'storage'
  @options[:metric] = nil
  @options[:history] = 10
  @options[:debug] = false

  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [options] ADMON_HOST"

    opts.on('--nodeid nodeID', String, 'FhGFS nodeID') do |nodeid|
      @options[:nodeid] = nodeid
    end
    
    opts.on('--nodenumid nodeNumID', String, 'FhGFS nodeNumID') do |nodenumid|
      @options[:nodenumid] = nodenumid
    end
    
    opts.on('-t', '--nodetype NODETYPE', 'FhGFS nodetype', "Options: #{DATA_MAPPER.keys.join(",")}") do |nodetype|
      nodetype.replace("meta") if nodetype == "metadata"
      @options[:nodetype] = nodetype
    end

    opts.on('-m', '--metric METRIC', 'iostat metric to return', String,
              "Options for storage:", "\t#{DATA_MAPPER['storage'].collect { |s| s[:metric] }.join(',')}",
              "Options for meta:", "\t#{DATA_MAPPER['meta'].collect { |s| s[:metric] }.join(',')}"
            ) do |metric|
              @options[:metric] = metric
    end
    
    opts.on('--history SECONDS', Integer, 'Number of seconds to average for metric value') do |history|
      @options[:history] = history
    end
    
    opts.on('-d', '--[no-]debug', 'enable debug output') do |debug|
      @options[:debug] = debug
    end

    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit 1
    end
  end
  
  begin
    optparse.parse!(args)

    @options[:admon_host] = args.first

    raise OptionParser::InvalidOption, "Invalid --nodetype" unless DATA_MAPPER.keys.include?(@options[:nodetype])
    
    raise OptionParser::InvalidOption, "Invalid --metric" unless DATA_MAPPER[@options[:nodetype]].map {|d| d[:metric] }.include?(@options[:metric])
    
    missing_options = mandatory_options.select { |o| @options[o.to_sym].nil? }
    raise OptionParser::MissingArgument, "Missing argument: #{missing_options.join(', ')}" unless missing_options.empty?
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts $!.to_s
    puts optparse
    exit 1
  end

  @options
end

def debug_output(msg, obj = nil, opts = {})
  return unless opts[:debug]
  puts "DEBUG: #{msg}"
  pp obj if obj
end

def get_node_num_id(opts)
  nodelist_url = "http://#{opts[:admon_host]}/XML_NodeList"
  debug_output("NodeList URL:", nodelist_url, opts)

  nodelist_xml = Net::HTTP.get_response(URI.parse(nodelist_url)).body
  nodelist_doc = REXML::Document.new(nodelist_xml)

  nodelist_xpath = "//#{opts[:nodetype]}/*[text() = '#{opts[:nodeid]}']"
  debug_output("Nodelist XPath:", nodelist_xpath, opts)

  nodelist_match = REXML::XPath.first(nodelist_doc, nodelist_xpath)
  nodelist_match.attributes["nodeNumID"]
end

def get_text_value_and_attr_value(element, data_map, opts)
  value = element.text
  
  case data_map[:attr]
  when 'time'
    now = Time.now.to_i
    attr_value = element.attributes["time"][0..-4].to_i
    return false unless ((now-opts[:history])..now).member?(attr_value)
  end
  
  { data_map[:attr] => attr_value, 'value' => value }
end

def get_attr_value(element, data_map, opts)
  value = element.attributes[data_map[:attr]]
  
  { 'value' => value }
end

def get_text_value(element, data_map, opts)
  value = element.text
  
  { 'value' => value }
end

def get_average(arr)
  average = arr.map { |x| x.to_f }.inject(:+) / arr.size.to_f
  sprintf("%.2f", average)
end

opts = parse(ARGV)
debug_output("Options:", opts, opts)

data_map = DATA_MAPPER[opts[:nodetype]].select { |d| d[:metric] == opts[:metric] }.first
debug_output("Data map:", data_map, opts)

if opts[:nodenumid].nil?
  opts[:nodenumid] = get_node_num_id(opts)
end

url = "http://#{opts[:admon_host]}/#{data_map[:uri_prefix]}?node=#{opts[:nodeid]}&nodeNumID=#{opts[:nodenumid]}&timeSpanRequests=10"
debug_output("URL:", url, opts)

xml = Net::HTTP.get_response(URI.parse(url)).body
doc = REXML::Document.new(xml)

values = []

doc.elements.each(data_map[:xpath]) do |element|
  if data_map[:text] and data_map[:attr]
    value_hash = get_text_value_and_attr_value(element, data_map, opts)
  elsif !data_map[:text] and data_map[:attr]
    value_hash = get_attr_value(element, data_map, opts)
  else
    value_hash = get_text_value(element, data_map, opts)
  end

  values << value_hash if value_hash
end

debug_output("Values:", values, opts)

if values.size == 1
  puts values.first["value"]
else
  puts get_average(values.map { |v| v["value"] })
end

exit 0
