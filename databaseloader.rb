require 'nokogiri'
require_relative 'quote'


f = File.open("wit-wisdom-quotes.html")
@doc = Nokogiri::HTML(f)
f.close

@quotes = @doc.css("blockquote p")

@quotes.each{| quote | 
    n = Quote.new
    n.content = quote
    n.created_at = Time.now
    n.save
}