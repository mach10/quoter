require 'twitter'
require_relative 'tweet'

class Tweeter


  def Tweeter.get_tweets(property)
    property = property.downcase
    msg = ''
    if cache_expired(property)
      Tweeter.load_tweet_cache property
    end
    @@tweet_cache[property].each do | t |
      msg = msg + t.to_xml
    end
    msg
  end

  def self.cache_expired(property)

    time_now = Time.new

    if @@cache_times[property].nil?
      @@cache_times[property] = time_now
    end

   last_updated  = @@cache_times[property]

  if (time_now - last_updated > (60 * 10))
    return true
  end


  @@tweet_cache[property].nil? || @@tweet_cache[property].empty?


  end

  def Tweeter.load_tweet_cache(property)

    puts 'loading tweetcache for '+property
    @@cache_times[property] = Time.new
    s = Set.new
    @@client.search('#'+property).take(20).each do | tweet |
      s.add(Tweet.new(tweet.text))
    end
      @@tweet_cache[property] = s
  end



  def Tweeter.load_user_lib( filename )
    JSON.parse( IO.read(filename) )
  end

  @@creds = Tweeter.load_user_lib('utils/creds.json')
  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = @@creds['consumer_key']
    config.consumer_secret     = @@creds['consumer_secret']
    config.access_token        = @@creds['access_token']
    config.access_token_secret = @@creds['access_token_secret']
  end
  @@tweet_cache = Hash.new
  @@cache_times = Hash.new
end