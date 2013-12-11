require 'isaac'
require 'rockstar'
require 'crack'
require 'open-uri'
require 'rest-client'
require 'mechanize'

Rockstar.lastfm = YAML.load_file('lastfm.yml')

configure do |c|
  c.nick    = "TheMusicBot"
  c.realname    = "TheShadowFog"
  c.server  = "irc.awfulnet.org"
  c.port    = 6667
end

on :connect do
 raw "PART #awful"
 join "#music"
end


on :channel, "!info" do
  msg channel, "Created by TheShadowFog"
end

on :channel, "!help" do
 raw "NOTICE #{nick} Basic commands:" 
 raw "NOTICE #{nick} !help !info !uptime !getquote quote this: !away !complete !twit !lyrics (replace spaces with plus signs: +)"
 raw "NOTICE #{nick} last.fm Commands"
 raw "NOTICE #{nick} !artist !np username, !user"
 raw "NOTICE #{nick} Reddit commands"
 raw "NOTICE #{nick} !karma"
 #msg channel, "Basic commands:"
 #msg channel, "=" * 10
 #msg channel, "!help !info !uptime !getquote quote this: "
 #msg channel, "last.fm Commands:"
 #msg channel, "=" * 10
 #msg channel, "!artist !sim"
end

on :channel, "!uptime" do
 uptime = `uptime`
 msg channel, uptime
end

on :channel, /^!artist (.*)/ do
artistname = match[0]
artistname2 = artistname.gsub(" ","+")
url = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{artistname2}&api_key=#{lastfm_api}"
page = open(url).read
parsed_xml = Crack::XML.parse(page)
image = parsed_xml['lfm']['artist']['image'][3]
artist = Rockstar::Artist.new(artistname, :include_info => true)
 msg channel, "Artist: #{artistname}"
 msg channel, artist.url	
 msg channel, "Listener Count: #{artist.listenercount}"
 msg channel, "Image: #{image}"
 #msg channel, user.recent_tracks.each { |t| t.name }

end

on :channel, /^quote this: (.*)/ do
 msg channel, "Quote: '#{match[0]}' by #{nick}"
 open("quotes.txt", "a") do |qu|
 qu.puts "Quote: '#{match[0]}' by #{nick}"
end
end	


on :channel, /^!fav (.*)/ do
user = match[0]
url = "http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=#{user}&api_key=#{lastfm_api}"
begin
page = open(url).read
parsed_xml = Crack::XML.parse(page)
song = parsed_xml['lfm']['toptracks']['track'][0]['name']
artist = parsed_xml['lfm']['toptracks']['track'][0]['artist']['name']
song2 = parsed_xml['lfm']['toptracks']['track'][1]['name']
artist2 = parsed_xml['lfm']['toptracks']['track'][1]['artist']['name']
song3 = parsed_xml['lfm']['toptracks']['track'][2]['name']
artist3 = parsed_xml['lfm']['toptracks']['track'][2]['artist']['name']
msg channel, "#{user}'s Top 3 Tracks:"
msg channel,  artist + " - " + song
msg channel,  artist2 + " - " + song2
msg channel,  artist3 + " - " + song3
rescue
msg channel, "USER NOT FOUND"
end
end
on :channel, /^(.*) slaps TheMusicBot with a large fish/ do
 msg channel, "I will kill #{nick} in his/her sleep!"
end

on :channel, /^!getquote/ do
 msg channel, File.readlines("quotes.txt").sample
end

on :channel, /^!away/ do
 msg channel, "ATTENTION EVERYONE: #{nick} is away."
end

on :channel, "^_^" do
 msg channel, "V_V"
end


on :channel, /^!complete (.*)/ do
 surl = match[0]
 url="http://en.wikipedia.org/w/api.php?action=opensearch&search=#{surl}&namespace=0"
 msg channel, Crack::JSON.parse(RestClient.get(url))
end

on :channel, /^!np (.*)/ do
user = match[0]
url  = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{user}&api_key=#{lastfm_api}"
begin
page = open(url).read
parsed_xml = Crack::XML.parse(page)
#artist = parsed_xml['lfm']['recenttracks']['track'][0]['artist']
#song = parsed_xml['lfm']['recenttracks']['track'][0]['name']
artist = parsed_xml['lfm']['recenttracks']['track'][0]['artist'] rescue 'THIS USER'
song = parsed_xml['lfm']['recenttracks']['track'][0]['name'] rescue 'HAS PLAYED NO TRACKS'
artist2 = artist.gsub(" ","+")
url2 = "http://ws.audioscrobbler.com/2.0/?method=artist.gettoptags&artist=#{artist2}&api_key=#{lastfm_api}"
page2 = open(url2).read
parsed_xml2 = Crack::XML.parse(page2)
tag0 = parsed_xml2['lfm']['toptags']['tag'][0]['name']
tag1 = parsed_xml2['lfm']['toptags']['tag'][1]['name']
tag2 = parsed_xml2['lfm']['toptags']['tag'][2]['name']
tag3 = parsed_xml2['lfm']['toptags']['tag'][3]['name']
msg channel, "#{user} is now playing: " + artist + " - " + song
msg channel, "\u00032Tags: " + tag0 + ", " + tag1 + ", " + tag2 + ", " + tag3 + "\u0003"
rescue
msg channel, "USER NOT FOUND"
#msg channel, tag0 + ", " + tag1 + ", " + tag2 + ", " + tag3
end
end


on :channel, /^!lyrics (\S+) (.*)/ do
artist = match[0]
song = match[1]
artist2 = artist.gsub(" ","+")
song2 = song.gsub(" ","+")
url = "http://lyrics.wikia.com/api.php?artist=#{artist2}&song=#{song2}&fmt=xml"
page = open(url).read
parsed_xml = Crack::XML.parse(page)
lartist = parsed_xml['LyricsResult']['artist']
lsong = parsed_xml['LyricsResult']['song']
#lyrics = parsed_xml['LyricsResult']['lyrics']
urll = parsed_xml['LyricsResult']['url']
msg channel, "Artist: #{lartist}"
msg channel, "Song: #{lsong}"
#msg channel, "Lyrics: " + parsed_xml['LyricsResult']['lyrics']
msg channel, "Url: #{urll}"
end

on :channel, /^!twit (.*)/ do
twituser = match[0]
tuser = "http://api.twitter.com/1/statuses/user_timeline.xml?count=100&screen_name=#{twituser}"
xml = open(tuser).read
parsed_xml = Crack::XML.parse(xml)
tweets = parsed_xml["statuses"]
first_tweet = tweets[0]
user = first_tweet["user"]
msg channel, "USERNAME: " + user["screen_name"]
msg channel, "NAME: " + user["name"]
msg channel, "Created on: " + user["created_at"]
msg channel, "Statuses: " + user["statuses_count"]
msg channel, "first tweet date: " + first_tweet["created_at"]
msg channel, "latest tweet: " +first_tweet["text"]
end

on :channel, /^!karma (.*)/ do
 username = match[0]
 url = "http://www.reddit.com/user/#{username}/about.json"
 page = open(url).read
 parsed_json = Crack::JSON.parse(page)
 uname = parsed_json['data']['name']
 linkkarma = parsed_json['data']['link_karma']
 commentkarma = parsed_json['data']['comment_karma']
 msg channel, "#{uname}"
 msg channel, "Link Karma: #{linkkarma}"
 msg channel, "Comment Karma: #{commentkarma}"
end

on :channel, /^!user (.*)/ do
user = match[0]
begin 
url = "http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=#{user}&api_key=#{lastfm_api}"
url2 = "http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=#{user}&api_key=#{lastfm_api}"
page = open(url).read
page2 = open(url2).read
parsed_xml = Crack::XML.parse(page)
parsed_xml2 = Crack::XML.parse(page2)
realname = parsed_xml2['lfm']['user']['name']
uurl = parsed_xml2['lfm']['user']['url']
age = parsed_xml2['lfm']['user']['age']
playcount = parsed_xml2['lfm']['user']['playcount']
image = parsed_xml2['lfm']['user']['image'][0]
msg channel, "Real Name: #{realname}"
msg channel, "Age: #{age}"
msg channel, "url: #{uurl}"
msg channel, "Play Count: #{playcount}"
msg channel, "image: #{image}"
msg channel, "#{user}'s top artists:"
for i in 0..3
msg channel,  parsed_xml['lfm']['topartists']['artist'][i]['name']
end
rescue
msg channel, "Couldn't find anymore info"
end
end

on :channel, /^!tag (.*)/ do
tag = match[0]
tag2 = tag.gsub(" ","+")
url = "http://ws.audioscrobbler.com/2.0/?method=tag.getinfo&tag=#{tag2}&api_key=#{lastfm_api}"
page = open(url).read
parsed_xml = Crack::XML.parse(page)
name = parsed_xml['lfm']['tag']['name']
summary = parsed_xml['lfm']['tag']['wiki']['summary']
uurl = parsed_xml['lfm']['tag']['url']
msg channel, "Name: #{name}"
msg channel, "Url: #{uurl}"
msg channel, summary
end
