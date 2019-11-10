#!/usr/bin/env ruby
require 'optparse'
require 'httparty'
require 'colorize'

def good(msg)
    puts '[+]'.green + " #{msg}"
end

def err(msg)
    puts '[x]'.red + " #{msg}"
end


options = {}
options[:type] = "http" 
options[:number] = 10
options[:country] = nil
options[:anon] = nil
options[:config] = '/etc/proxychains.conf'
options[:stdout] = false
options[:shuffle] = false
options[:pairs] = false

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: proxadd.rb [-h] [-s] [-t TYPE] [-n NUMBER] [-cn CODE] [-a ANON] [-cf CONFIG]"
    opts.on('-t', '--type TYPE', 'Select proxies type to query [*http|https|socks4|socks5]') do |type|
        options[:type] = type
    end
    opts.on('-n', '--number NUMBER', 'Number of proxies to add to proxychains config') do |number|
        options[:number] = number
    end
    opts.on('-c', '--country-code CODE', 'Filter proxies by country code') do |country|
        options[:country] = "&country=#{country}"
    end
    opts.on('-a', '--anon ANON', 'Filter by anonimity level [transparent|anonymous|elite]') do |anon|
        options[:anon] = "&anon=#{anon}"
    end
    opts.on('-f', '--config-file CONFIG', 'Path of the Proxychains config file (default: /etc/proxychains.conf)') do |config|
        options[:config] = config
    end
    opts.on('-o', '--stdout', 'Print proxies to SDTOUT instead of writing to config file') do
        options[:stdout] = true
    end
    opts.on('-s', '--shuffle', 'Shuffle proxies list before adding to config file') do 
        options[:shuffle] = true
    end
    opts.on('-p', '--pairs', 'Return proxies in <host>:<port> value pairs') do 
        options[:pairs] = true
    end
    opts.on('-h', '--help', 'Print help message') do
        puts opts
        exit
    end
end

optparse.parse!
request = "https://www.proxy-list.download/api/v1/get?type=#{options[:type]}#{options[:anon]}#{options[:country]}"
response = HTTParty.get(request)
if response.code != 200 then
    err("HTTP error: #{response.code}")
    exit
end
config_file = open(options[:config], "a")
proxies = response.body.split("\n")
proxies = proxies.first(options[:number].to_i)
if options[:shuffle] then
    proxies = proxies.shuffle
end
proxies.each do |proxy|
    proxy_addr = proxy.split(":")[0]
    proxy_port = proxy.split(":")[1]
    proxy_info_line = "#{options[:type]} #{proxy_addr} #{proxy_port}"
    if options[:pairs]
        proxy_info_line = "#{proxy_addr}:#{proxy_port}"
    end
    if options[:stdout]
        puts proxy_info_line
    else
        config_file.puts(proxy_info_line)
    end
end
if not options[:stdout] 
    good("Added #{proxies.length} proxies to #{options[:config]}")
end
