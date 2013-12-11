require 'rubygems'
require 'isaac'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

#RSS 
source = "http://www.world2ch.org/board/index.rss" # url or local file
content = "" # raw content of rss feed will be loaded here
open(source) do |s| content = s.read end
rss = RSS::Parser.parse(content, false)
title = rss.channel.title
latestpost = rss.items[0].title
descrp = rss.items[0].description
lol = system("artii lol")

#puts rss
#print "RSS title: ", rss.channel.title, "\n"
#print "title of first item: ", rss.items[0].title, "\n"
#print "description of first item: ", rss.items[0].description, "\n"


configure do |c|
c.nick = "VIPServ"
c.server = "irc.synirc.net"
c.port = "6667"
c.verbose = true
end


on :connect do
join "#world2ch"
end

a = "#{descrp}".delete "<p>/"

on :channel, /^!rss/ do
msg channel, title
msg channel, latestpost
msg channel, "#{a}"
end

on :channel, /^!help/ do
msg channel, "!rss !help !about"
end
on :channel, /^!about/ do
msg channel, "I was created by my wonderful creator TheShadowFog!WuvOsumF7w"
msg channel, "https://github.com/Gregoryx12/VIPserv"
msg channel, "RUBY"
end

on :channel, /^!aa/ do
msg channel, lol
end

on :channel, /.*/ do
  open("#{channel}.log", "a") do |log|
    log.puts "#{nick}: #{message}"
  end

  puts "#{channel}: #{nick}: #{message}"
end

