require 'sinatra'
require 'nokogiri'
#require 'data_mapper'
SITE_TITLE="Wit and Wisdom"
#part one http://code.tutsplus.com/tutorials/singing-with-sinatra--net-18965
#part two http://code.tutsplus.com/tutorials/singing-with-sinatra-the-recall-app--net-19128
#part threee http://code.tutsplus.com/tutorials/singing-with-sinatra-the-encore--net-19364

#DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

#sinatra default port = 4567 
class Quote
  def initialize(content)
    @content = content
  end  
end
 
#DataMapper.finalize.auto_upgrade!
#to help stop XSS by converting all input into html entities
helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

def get_quotes
  f = File.open("wit-wisdom-quotes.html")
  doc = Nokogiri::HTML(f)
  f.close
  quotes = Array.new
  doc.css("blockquote p").each{|content| quotes << content}
  quotes
end


get '/quote' do
  content_type 'text/xml'
  @quotes = get_quotes
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+@quotes[1 + rand(@quotes.length)].to_xml
end


