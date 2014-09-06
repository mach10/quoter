class Tweet

  attr_reader :tweet

  def initialize(tweet)
    @tweet = tweet

  end

  def to_xml
    '<tweet>'+@tweet+'</tweet>'
  end

  def to_s
    @tweet
  end
end